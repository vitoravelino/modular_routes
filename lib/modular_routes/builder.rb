# frozen_string_literal: true

module ModularRoutes
  class Builder
    HTTP_METHODS = [:post, :get, :put, :patch, :delete].freeze

    attr_reader :routes

    def initialize(scope_options)
      @scope_options = scope_options
      @routes = build_resource_routes
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |action, options = {}|
        @routes.unshift(Route::Inner.new(method, action, options))
      end
    end

    private def build_resource_routes
      @scope_options.actions.map { |action| build_resource_route(action) }
    end

    private def build_resource_route(action)
      Route::Resource.new(@scope_options, action)
    end
  end
end
