# frozen_string_literal: true

module ModularRoutes
  module Route
    class Resource
      attr_reader :scope_options

      def initialize(scope_options, action)
        @module = scope_options.module
        @method = scope_options.method
        @options = scope_options.options
        @action = action
      end

      def args
        [@method, @module, resource_options]
      end

      private def resource_options
        @options.merge({
          controller: @action,
          only: @action,
          action: :call,
          module: @module,
        })
      end
    end
  end
end
