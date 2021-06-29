# frozen_string_literal: true

DEFAULT_ACTIONS = [:index, :create, :edit, :new, :show, :update, :destroy].freeze
DEFAULT_API_ACTIONS = [:index, :create, :show, :update, :destroy].freeze

RSpec.describe ModularRoutes::Builder do
  subject(:builder) { described_class.new(route_options) }

  let(:route_options) { ModularRoutes::Options.new(resources: resource_name, **options) }
  let(:resource_name) { :items }
  let(:resource_method) { :resources }
  let(:options) { Hash[all: true] }

  it "generates resource routes by default" do
    expect(builder.routes.first).to be_a(ModularRoutes::Route::Resource)
  end

  it "builds resource routes by default (size)" do
    expect(builder.routes.size).to eq(DEFAULT_ACTIONS.size)
  end

  context "when only: [:index, :show]" do
    let(:options) { Hash[only: [:index, :show]] }

    it "builds specified resource routes" do
      expect(builder.routes.first).to be_a(ModularRoutes::Route::Resource)
    end

    it "builds specified routes (size)" do
      expect(builder.routes.size).to eq(2)
    end
  end

  it "defines instance methods for each http verb" do
    described_class::HTTP_METHODS.each do |action|
      expect(builder).to respond_to(action)
    end
  end

  describe "#get" do
    it "builds inner route" do
      builder.get(:sent, on: :member)
      inner_route = builder.routes.first

      expect(inner_route.http_method).to eq(:get)
      expect(inner_route.action).to eq(:sent)
    end
  end
end
