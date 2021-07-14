# frozen_string_literal: true

class FakeMapper
  HTTP_METHODS = [:post, :get, :put, :patch, :delete].freeze

  def initialize
    @non_restful = []
  end

  def resource(*args, &block)
    @resource = args
    yield if block
  end

  def resources(*args, &block)
    @resources = args
    yield if block
  end

  def state
    {
      resource: @resource,
      resources: @resources,
      non_restful: @non_restful,
    }
  end

  HTTP_METHODS.each do |method|
    define_method(method) do |action, options = {}|
      @non_restful << [method, options]
    end
  end
end
