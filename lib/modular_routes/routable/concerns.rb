# frozen_string_literal: true

module ModularRoutes
  module Routable
    class Concerns
      def initialize(name)
        @name = name
      end

      def apply(mapper)
        mapper.concerns(@name)
      end
    end

    private_constant :Concerns
  end
end
