# frozen_string_literal: true

module ModularRoutes
  module Routable
    class Standalone
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
        to = @options.fetch(:to, nil)

        if namespace_controller_pattern?(to)
          namespace, controller = to.split("#")
          @options[:to] = "#{namespace}/#{controller}##{@controller_method}"
        end

        @options
      end

      private def namespace_controller_pattern?(obj)
        obj.is_a?(String) && obj.include?("#")
      end
    end

    private_constant :Standalone
  end
end
