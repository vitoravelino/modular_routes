# frozen_string_literal: true

module ModularRoutes
  class Options
    attr_reader :method
    attr_reader :module
    attr_reader :resource
    attr_reader :options

    def initialize(options)
      @options = options
      @method = extract_resource_method
      @resource = @options.delete(@method)
      @module = @options.fetch(:module, @resource)
      @api = @options.delete(:api_only) { false }

      @only = @options.delete(:only)
      @except = @options.delete(:except)
      @all = @options.delete(:all)
    end

    def singular?
      method == :resource
    end

    def actions
      return default_actions if @all

      return default_actions - Array(@except) if @except

      Array(@only)
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
