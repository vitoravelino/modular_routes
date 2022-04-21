# frozen_string_literal: true

module ModularRoutes
  module Routable
    class NonRestful
      def initialize(http_method, action, options)
        @http_method = http_method
        @action = action
        @options = options.except(:controller_method)
        @controller_method = options.fetch(:controller_method)
      end

      def apply(mapper)
        mapper.public_send(@http_method, @action, options)
      end

      private def options
        mutable_options = {
          to: "#{@action}##{@controller_method}",
        }

        mutable_options.merge(@options)
      end
    end

    private_constant :NonRestful
  end
end
