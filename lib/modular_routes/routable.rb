# frozen_string_literal: true

module ModularRoutes
  module Routable
    def self.for(type, *args)
      case type
      when :standalone then Standalone.new(*args)
      when :non_restful then NonRestful.new(*args)
      when :restful then Restful.new(*args)
      else raise NotImplementedError
      end
    end
  end
end
