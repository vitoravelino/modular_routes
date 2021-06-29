# frozen_string_literal: true

module ModularRoutes
  module Route
    class Resource
      def initialize(route_options, action)
        @module = route_options.module
        @resource = route_options.resource
        @options = route_options.options
        @method = route_options.method
        @action = action
      end

      def args
        [@method, @resource, resource_options]
      end

      private def resource_options
        immutable_options = {
          controller: @action,
          only: @action,
          action: :call,
        }

        mutable_options = { module: @module }

        mutable_options.merge(@options).merge(immutable_options)
      end
    end
  end
end
