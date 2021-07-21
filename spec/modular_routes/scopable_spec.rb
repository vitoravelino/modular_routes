# frozen_string_literal: true

RSpec.describe ModularRoutes::Scopable do
  subject(:scopable) { described_class }

  it "raises NotImplementedError" do
    expect { scopable.for(:inexistent) }.to raise_error(NotImplementedError)
  end
end
