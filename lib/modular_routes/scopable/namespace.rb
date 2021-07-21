# frozen_string_literal: true

module ModularRoutes
  module Scopable
    class Namespace
      def initialize(name, options)
        @name = name
        @options = options.except(:api_only)

        @children = []
      end

      def add(route_or_scope)
        @children << route_or_scope
      end

      def resource?
        false
      end

      def apply(mapper)
        mapper.namespace(@name, @options) do
          @children.each { |route_or_scope| route_or_scope.apply(mapper) }
        end
      end
    end

    private_constant :Namespace
  end
end
