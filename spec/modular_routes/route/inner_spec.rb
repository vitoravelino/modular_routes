# frozen_string_literal: true

RSpec.describe ModularRoutes::Route::Inner do
  subject(:inner_route) { described_class.new(http_method, action, options) }

  let(:http_method) { :post }
  let(:action) { :create }
  let(:options) { Hash[path: "something", other: "other", on: :collection] }

  let(:expected_options) { Hash[to: "#{action}#call", other: "other", on: :collection, path: nil] }

  it "returns :to option" do
    expect(inner_route.args.last[:to]).to eq(expected_options[:to])
  end

  it "overrides :path to nil" do
    path = inner_route.args.last[:path]

    expect(path).to be_nil
  end

  it "returns args to be executed within resource(s) block" do
    # send(http_verb, :create, options)
    expect(inner_route.args).to eq([:post, :create, expected_options])
  end
end
