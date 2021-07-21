# frozen_string_literal: true

module ModularRoutes
  module Extension
    def modular_routes(**options, &block)
      api_only = options.fetch(:api_only, api_only?)

      route_builder = Builder.new(api_only: api_only)
      route_builder.instance_eval(&block)
      route_builder.routes.each { |route| route.apply(self) }
    end
  end
end
