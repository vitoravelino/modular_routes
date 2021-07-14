# frozen_string_literal: true

RSpec.describe ModularRoutes::Route::NonRestful do
  subject(:route) { described_class.new(http_method, action, options, route_options) }

  let(:http_method) { :post }
  let(:action) { :create }
  let(:options) { Hash[path: "something", other: "other", on: :collection] }
  let(:route_options) { ModularRoutes::Options.new(resources: :items) }

  it "raises ArgumentError unless :on present" do
    msg = "Non-RESTful route should be declared inside `member`/`collection` block or using `:on` key"

    expect do
      described_class.new(http_method, action, options.except(:on), route_options)
    end.to raise_error(ArgumentError, msg)
  end

  it "creates context by calling empty resources" do
    mapper = FakeMapper.new
    expected = [:items, { module: :items, only: [] }]

    route.apply(mapper)

    expect(mapper.state[:resources]).to eq(expected)
  end

  it "calls post :create" do
    mapper = FakeMapper.new
    expected = [:post, { to: "create#call", path: "something", other: "other", on: :collection }]

    route.apply(mapper)

    expect(mapper.state[:non_restful]).to include(expected)
  end
end
