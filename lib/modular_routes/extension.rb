# frozen_string_literal: true

module ModularRoutes
  module Extension
    def modular_route(options = {}, &block)
      raise ArgumentError, "Expected argument to be a Hash instead of #{options.class}" unless options.is_a?(Hash)

      scope_options = ScopeOptions.new(options.merge(api_only: api_only?))
      route_mapper = Mapper.new(self, scope_options)

      route_builder = Builder.new(scope_options)
      route_builder.instance_eval(&block) if block
      route_builder.routes.each { |route| route_mapper.apply(route) }
    end
  end
end
