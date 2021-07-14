# frozen_string_literal: true

RSpec.describe ModularRoutes::Route::Restful do
  subject(:route) { described_class.new(route_options, action) }

  let(:resource_name) { :items }
  let(:action) { :create }
  let(:options) { Hash[path: "other_path"] }

  let(:route_options) { ModularRoutes::Options.new(resource_type => resource_name, only: [action], **options) }

  context "when resource" do
    let(:resource_type) { :resource }

    it "calls mapper.resource" do
      mapper = FakeMapper.new
      expected = [:items, { module: :items, path: "other_path", controller: :create, only: :create, action: :call }]

      route.apply(mapper)

      expect(mapper.state[resource_type]).to eq(expected)
    end
  end

  context "when resources" do
    let(:resource_type) { :resources }

    it "calls mapper.resources" do
      mapper = FakeMapper.new
      expected = [:items, { module: :items, path: "other_path", controller: :create, only: :create, action: :call }]

      route.apply(mapper)

      expect(mapper.state[resource_type]).to eq(expected)
    end
  end
end
