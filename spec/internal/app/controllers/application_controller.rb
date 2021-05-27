# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def call
    render(plain: "#{self.class.name}##{__method__}")
  end
end
