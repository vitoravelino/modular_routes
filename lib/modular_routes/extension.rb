# frozen_string_literal: true

module ModularRoutes
  module Extension
    def modular_route(options, &block)
      route_options = Options.new(options.merge(api_only: api_only?))
      route_builder = Builder.new(route_options)
      route_builder.instance_eval(&block) if block
      route_builder.routes.each { |route| route.apply(self) }
    end
  end
end
