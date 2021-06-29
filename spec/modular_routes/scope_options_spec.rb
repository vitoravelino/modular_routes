# frozen_string_literal: true

RSpec.describe ModularRoutes::Options do
  subject(:route_options) { described_class.new(options) }

  let(:options) { Hash[resources: :items, all: true] }

  it "responds to singular? (false)" do
    expect(route_options).not_to be_singular
  end

  it "parses scope method" do
    expect(route_options.method).to eq(:resources)
  end

  it "parses scope module" do
    expect(route_options.module).to eq(:items)
  end

  it "returns expected actions" do
    expect(route_options.actions).to(eq([:index, :create, :new, :edit, :show, :update, :destroy]))
  end

  context "when resource and singular" do
    let(:options) { Hash[resource: :profile, all: true] }

    it "responds to singular? (true)" do
      expect(route_options).to be_singular
    end

    it "parses scope method" do
      expect(route_options.method).to eq(:resource)
    end

    it "excludes :index action" do
      expect(route_options.actions).to eq([:create, :new, :edit, :show, :update, :destroy])
    end
  end

  context "when only: [:index, :show]" do
    let(:options) { Hash[resources: :items, api_only: true, only: [:index, :show]] }

    it "returns specified actions" do
      expect(route_options.actions).to eq([:index, :show])
    end
  end

  context "when only: []" do
    let(:options) { Hash[resources: :items, api_only: true, only: []] }

    it "returns no actions" do
      expect(route_options.actions).to be_empty
    end
  end

  context "when except: [:destroy]" do
    let(:options) { Hash[resources: :items, except: [:destroy]] }

    it "excludes :destroy" do
      expect(route_options.actions).not_to include(:destroy)
    end

    it "returns the others actions" do
      expect(route_options.actions).to eq([:index, :create, :new, :edit, :show, :update])
    end
  end

  context "when api mode is enabled" do
    let(:options) { Hash[resources: :items, api_only: true, all: true] }

    it "excludes :new and :edit actions" do
      expect(route_options.actions).to eq([:index, :create, :show, :update, :destroy])
    end
  end

  context "when no :resource or :resources" do
    let(:options) { Hash[] }

    it "raises ArgumentError if no scope method passed" do
      expect { route_options }.to raise_error(ArgumentError)
    end
  end
end
