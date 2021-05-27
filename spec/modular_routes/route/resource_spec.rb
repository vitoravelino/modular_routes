# frozen_string_literal: true

RSpec.describe ModularRoutes::Route::Resource do
  subject(:resource_route) { described_class.new(scope_options, action) }

  let(:resource_name) { :items }
  let(:action) { :create }
  let(:options) { Hash[path: "other_path"] }

  let(:scope_options) { ModularRoutes::ScopeOptions.new(resources: resource_name, only: [action], **options) }

  let(:resource_options) do
    {
      path: options.fetch(:path, nil),
      only: action,
      controller: action,
      action: :call,
      module: resource_name,
    }
  end

  it "returns args to be executed with resource(s)" do
    # send(:resource | :resources, :create, resource_options)
    expect(resource_route.args).to eq([:resources, :items, resource_options])
  end
end
