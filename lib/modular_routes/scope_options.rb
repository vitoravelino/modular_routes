# frozen_string_literal: true

module ModularRoutes
  class ScopeOptions
    attr_reader :method
    attr_reader :module
    attr_reader :options

    def initialize(options)
      @options = options
      @method = extract_resource_method
      @module = options.delete(@method)
      @api = options.delete(:api_only) { false }

      @only = options.delete(:only) { default_actions }
      @except = options.delete(:except)
    end

    def singular?
      method == :resource
    end

    def actions
      Array(@only) - Array(@except)
    end

    private def default_actions
      actions = [:index, :create, :new, :edit, :show, :update, :destroy]

      actions -= [:index] if singular?
      actions -= [:edit, :new] if @api

      actions
    end

    private def extract_resource_method
      return :resource if options.include?(:resource)
      return :resources if options.include?(:resources)

      raise ArgumentError, "you must specify :resource or :resources for `modular_route`"
    end
  end
end
