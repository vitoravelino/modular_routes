# frozen_string_literal: true

module ModularRoutes
  class Builder
    HTTP_METHODS = [:post, :get, :put, :patch, :delete].freeze

    attr_reader :routes

    def initialize(route_options)
      @route_options = route_options
      @routes = build_resource_routes
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |action, options = {}|
        mutable_options = { on: @on }
        merged_options = mutable_options.merge(options)

        @routes.unshift(Route::Inner.new(method, action, merged_options))
      end
    end

    def collection
      @on = :collection
      yield
    ensure
      @on = nil
    end

    def member
      @on = :member
      yield
    ensure
      @on = nil
    end

    private def build_resource_routes
      @route_options.actions.map { |action| build_resource_route(action) }
    end

    private def build_resource_route(action)
      Route::Resource.new(@route_options, action)
    end
  end
end
