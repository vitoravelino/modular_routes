# frozen_string_literal: true

module ModularRoutes
  class Builder
    HTTP_METHODS = [:post, :get, :put, :patch, :delete].freeze

    attr_reader :routes

    def initialize(api_only:, controller_method:)
      @api_only = api_only
      @controller_method = controller_method
      @scopes = []
      @routes = []
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |action, action_options = {}|
        options = { on: @on }.merge(action_options)
        routable = build_routable(method, action, options)

        if current_scope
          current_scope.add(routable)
        else
          @routes.unshift(routable)
        end
      end
    end

    def root(*, **)
      raise SyntaxError, "You must call `root` outside of `modular_routes` block"
    end

    def concerns(names)
      raise SyntaxError, "You must call `concerns` inside of a resource block" unless current_scope

      Array(names).each do |name|
        concern = Routable.for(:concerns, name)
        current_scope.add(concern)
      end
    end

    def collection(&block)
      apply_inner_scope(:collection, &block)
    end

    def member(&block)
      apply_inner_scope(:member, &block)
    end

    def new(&block)
      apply_inner_scope(:new, &block)
    end

    def namespace(namespace_name, **options, &block)
      apply_scopable(:namespace, namespace_name, options, &block)
    end

    def concern(concern_name, **options, &block)
      apply_scopable(:concern, concern_name, options, &block)
    end

    def scope(*args, **options, &block)
      apply_scopable(:scope, args, options, &block)
    end

    def resources(resources_name, **options, &block)
      apply_scopable(:resources, resources_name, options, &block)
    end

    def resource(resource_name, **options, &block)
      apply_scopable(:resource, resource_name, options, &block)
    end

    private def build_routable(method, action, options)
      routable = if current_scope&.resource?
        :non_restful
      else
        :standalone
      end

      Routable.for(routable, method, action, options.merge(controller_method: @controller_method))
    end

    private def build_scopable(type, name, options)
      Scopable.for(type, name, options.merge(api_only: @api_only, controller_method: @controller_method))
    end

    private def apply_scopable(type, name, options, &block)
      scopable = build_scopable(type, name, options)
      current_scope&.add(scopable)

      apply_scope(scopable, &block)
    end

    private def apply_scope(scopable, &block)
      @scopes << scopable

      block&.call

      @scopes.pop
      @routes.push(scopable) unless current_scope
    end

    private def apply_inner_scope(type)
      @on = type

      yield

      @on = nil
    end

    private def current_scope
      @scopes.last
    end
  end
end
