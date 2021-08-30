# frozen_string_literal: true

module ModularRoutes
  module Scopable
    class Concern
      def initialize(name, options)
        @name = name
        @options = options.except(:api_only)

        @children = []
      end

      def add(route_or_scope)
        @children << route_or_scope
      end

      def resource?
        true
      end

      def apply(mapper)
        block = proc do
          @children.each { |route_or_scope| route_or_scope.apply(mapper) }
        end

        mapper.concern(@name, block)
      end
    end

    private_constant :Concern
  end
end
