# frozen_string_literal: true

module ModularRoutes
  class Mapper
    attr_reader :mapper
    attr_reader :route_options

    def initialize(mapper, route_options = {})
      @mapper = mapper
      @route_options = route_options
    end

    def apply(route)
      case route
      when Route::Resource
        apply_route(route)
      when Route::Inner
        apply_inner_route(route)
      end
    end

    private def apply_inner_route(route)
      method = route_options.method
      resource = route_options.resource

      mapper.send(method, resource, resource_options_inner_route) do
        apply_route(route)
      end
    end

    private def apply_route(route)
      mapper.send(*route.args)
    end

    private def resource_options_inner_route
      immutable_options = {
        only: [],
        module: route_options.module,
      }

      route_options.options.merge(immutable_options)
    end
  end
end
