# frozen_string_literal: true

module ModularRoutes
  module Scopable
    class Resource
      attr_reader :name
      attr_reader :options

      def initialize(name, options)
        @name = name
        @children = []

        @api_only = options.delete(:api_only)
        @only = options.delete(:only) { default_actions }
        @except = options.delete(:except)
        @concerns = Array(options.delete(:concerns))
        @options = { module: name, only: [] }.merge(options)
      end

      def resource?
        true
      end

      def resource_type
        :resources
      end

      def add(route_or_scope)
        @children << route_or_scope
      end

      def apply(mapper)
        mapper.public_send(resource_type, @name, @options.except(:controller_method)) do
          @children.each { |route_or_scope| route_or_scope.apply(mapper) }

          apply_concerns(mapper)
        end

        apply_restful_actions(mapper)
      end

      private def actions
        return default_actions - Array(@except) if @except

        Array(@only)
      end

      private def default_actions
        if @api_only
          [:index, :create, :show, :update, :destroy]
        else
          [:index, :create, :new, :edit, :show, :update, :destroy]
        end
      end

      private def apply_restful_actions(mapper)
        actions.each do |action|
          Routable.for(:restful, action, self).apply(mapper)
        end
      end

      private def apply_concerns(mapper)
        @concerns.each do |concern|
          Routable.for(:concerns, concern).apply(mapper)
        end
      end
    end

    private_constant :Resource
  end
end
