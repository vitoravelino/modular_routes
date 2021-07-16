# frozen_string_literal: true

module ModularRoutes
  module Routable
    class NonRestful
      def initialize(http_method, action, options)
        @http_method = http_method
        @action = action
        @options = options
      end

      def apply(mapper)
        mapper.public_send(@http_method, @action, options)
      end

      private def options
        mutable_options = {
          to: "#{@action}#call",
        }

        mutable_options.merge(@options)
      end
    end

    private_constant :NonRestful
  end
end
