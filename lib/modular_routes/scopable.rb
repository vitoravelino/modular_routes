# frozen_string_literal: true

module ModularRoutes
  module Scopable
    def self.for(type, *args)
      case type
      when :namespace then Namespace.new(*args)
      when :resources then Resource.new(*args)
      when :resource then SingleResource.new(*args)
      when :scope then Scope.new(*args)
      else raise NotImplementedError
      end
    end
  end
end
