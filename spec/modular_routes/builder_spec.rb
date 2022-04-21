# frozen_string_literal: true

RSpec.describe ModularRoutes::Builder do
  subject(:builder) { described_class.new(api_only: false, controller_method: "call") }

  describe "#concerns" do
    it "raises SyntaxError" do
      expect { builder.concerns(:whatever) }.to raise_error(SyntaxError)
    end
  end

  describe "#root" do
    it "raises SyntaxError" do
      expect { builder.root("controller#method") }.to raise_error(SyntaxError)
      expect { builder.root(to: "controller#method") }.to raise_error(SyntaxError)
    end
  end
end
