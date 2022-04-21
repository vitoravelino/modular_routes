# frozen_string_literal: true

module ModularRoutes
  module Scopable
    class Scope
      def initialize(args, options)
        @args = args
        @options = options.except(:api_only, :controller_method)

        @children = []
      end

      def add(route_or_scope)
        @children << route_or_scope
      end

      def resource?
        false
      end

      def apply(mapper)
        mapper.scope(*@args, @options) do
          @children.each { |route_or_scope| route_or_scope.apply(mapper) }
        end
      end
    end

    private_constant :Scope
  end
end
