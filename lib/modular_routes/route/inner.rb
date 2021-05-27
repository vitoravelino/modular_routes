# frozen_string_literal: true

module ModularRoutes
  module Route
    class Inner
      attr_reader :http_method
      attr_reader :action

      def initialize(http_method, action, options)
        @http_method = http_method
        @action = action
        @options = options
      end

      def args
        [http_method, action, options]
      end

      private def options
        p @options
        raise "You must specify :on property for non-resource routes" unless @options.key?(:on)
        # Hash[to: "#{action}#call"].merge(@options)
        @options.merge(to: "#{action}#call", path: nil)
      end
    end
  end
end
