# frozen_string_literal: true

RSpec.describe ModularRoutes::Builder do
  subject(:builder) { described_class.new(api_only: false) }

  describe "#concerns" do
    it "raises SyntaxError" do
      expect { builder.concerns(:whatever) }.to raise_error(SyntaxError)
    end
  end
end
