# frozen_string_literal: true

module ModularRoutes
  module Scopable
    class SingleResource < Resource
      def resource_type
        :resource
      end

      private def default_actions
        if @api_only
          [:create, :show, :update, :destroy]
        else
          [:create, :new, :edit, :show, :update, :destroy]
        end
      end
    end

    private_constant :SingleResource
  end
end
