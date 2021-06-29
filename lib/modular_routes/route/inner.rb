# frozen_string_literal: true

module ModularRoutes
  module Route
    class Inner
      attr_reader :http_method
      attr_reader :action

      def initialize(http_method, action, options = {})
        @http_method = http_method
        @action = action
        @options = options

        raise "You must specify :on property for non-resource routes" unless @options.fetch(:on, nil)
      end

      def args
        [http_method, action, options]
      end

      private def options
        immutable_options = {
          to: "#{action}#call",
          path: nil,
        }

        @options.merge(immutable_options)
      end
    end
  end
end
