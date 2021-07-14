# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.start do
    enable_coverage :branch
    minimum_coverage 100

    add_filter "/spec/"
  end
end
