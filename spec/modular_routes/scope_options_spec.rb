# frozen_string_literal: true

RSpec.describe ModularRoutes::ScopeOptions do
  subject(:scope_options) { described_class.new(options) }

  let(:options) { Hash[resources: :items] }

  it "responds to singular? (false)" do
    expect(scope_options).not_to be_singular
  end

  it "parses scope method" do
    expect(scope_options.method).to eq(:resources)
  end

  it "parses scope module" do
    expect(scope_options.module).to eq(:items)
  end

  it "returns expected actions" do
    expect(scope_options.actions).to(eq([:index, :create, :new, :edit, :show, :update, :destroy]))
  end

  context "when resource and singular" do
    let(:options) { Hash[resource: :profile] }

    it "responds to singular? (true)" do
      expect(scope_options).to be_singular
    end

    it "parses scope method" do
      expect(scope_options.method).to eq(:resource)
    end

    it "excludes :index action" do
      expect(scope_options.actions).to eq([:create, :new, :edit, :show, :update, :destroy])
    end
  end

  context "when only: [:index, :show]" do
    let(:options) { Hash[resources: :items, api_only: true, only: [:index, :show]] }

    it "returns specified actions" do
      expect(scope_options.actions).to eq([:index, :show])
    end
  end

  context "when only: []" do
    let(:options) { Hash[resources: :items, api_only: true, only: []] }

    it "returns no actions" do
      expect(scope_options.actions).to be_empty
    end
  end

  context "when except: [:destroy]" do
    let(:options) { Hash[resources: :items, except: [:destroy]] }

    it "excludes :destroy" do
      expect(scope_options.actions).not_to include(:destroy)
    end

    it "returns the others actions" do
      expect(scope_options.actions).to eq([:index, :create, :new, :edit, :show, :update])
    end
  end

  context "when api mode is enabled" do
    let(:options) { Hash[resources: :items, api_only: true] }

    it "excludes :new and :edit actions" do
      expect(scope_options.actions).to eq([:index, :create, :show, :update, :destroy])
    end
  end

  context "when no :resource or :resources" do
    let(:options) { Hash[] }

    it "raises ArgumentError if no scope method passed" do
      expect { scope_options }.to raise_error(ArgumentError)
    end
  end
end
