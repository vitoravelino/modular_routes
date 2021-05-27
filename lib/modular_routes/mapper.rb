# frozen_string_literal: true

module ModularRoutes
  class Mapper
    attr_reader :mapper
    attr_reader :scope_options

    def initialize(mapper, scope_options = {})
      @mapper = mapper
      @scope_options = scope_options
    end

    def apply(route)
      if route.is_a?(Route::Resource)
        apply_route(route)
      else
        apply_inner_route(route)
      end
    end

    private def apply_inner_route(route)
      resource_module = scope_options.module
      resource_options = scope_options.options.merge(only: [], module: resource_module)

      mapper.send(scope_options.method, resource_module, resource_options) do
        apply_route(route)
      end
    end

    private def apply_route(route)
      mapper.send(*route.args)
    end
  end
end
