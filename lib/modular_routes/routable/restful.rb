# frozen_string_literal: true

module ModularRoutes
  module Routable
    class Restful
      def initialize(action, resource)
        @action = action
        @resource = resource
        @controller_method = resource.options.fetch(:controller_method)
      end

      def apply(mapper)
        mapper.public_send(resource_type, resource_name, options)
      end

      private def resource_type
        @resource.resource_type
      end

      private def resource_name
        @resource.name
      end

      private def resource_options
        @resource.options.except(:controller_method)
      end

      private def options
        immutable = {
          controller: @action,
          only: @action,
          action: @controller_method,
        }

        resource_options.merge(immutable)
      end
    end

    private_constant :Restful
  end
end
