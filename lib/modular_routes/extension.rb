# frozen_string_literal: true

module ModularRoutes
  module Extension
    def modular_routes(**options, &block)
      api_only = options.fetch(:api_only, api_only?)
      controller_method = options.fetch(:controller_method, 'call')

      route_builder = Builder.new(api_only: api_only, controller_method: controller_method)
      route_builder.instance_eval(&block)
      route_builder.routes.each { |route| route.apply(self) }
    end
  end
end
