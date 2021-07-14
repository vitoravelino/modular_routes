# frozen_string_literal: true

module ModularRoutes
  module Route
    class NonRestful
      attr_reader :http_method
      attr_reader :action

      def initialize(http_method, action, options, scope_options)
        @http_method = http_method
        @action = action
        @options = options
        @scope_options = scope_options

        unless @options.fetch(:on, nil)
          raise ArgumentError,
            "Non-RESTful route should be declared inside `member`/`collection` block or using `:on` key"
        end
      end

      def apply(mapper)
        method = @scope_options.method
        resource = @scope_options.resource

        mapper.public_send(method, resource, resource_options) do
          mapper.public_send(http_method, action, options)
        end
      end

      private def resource_options
        immutable_options = {
          only: [],
          module: @scope_options.module,
        }

        @scope_options.options.merge(immutable_options)
      end

      private def options
        mutable_options = {
          to: "#{action}#call",
        }

        mutable_options.merge(@options)
      end
    end
  end
end
