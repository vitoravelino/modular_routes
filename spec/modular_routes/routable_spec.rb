# frozen_string_literal: true

RSpec.describe ModularRoutes::Routable do
  subject(:routable) { described_class }

  it "raises NotImplementedError" do
    expect { routable.for(:inexistent) }.to raise_error(NotImplementedError)
  end
end
