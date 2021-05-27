# frozen_string_literal: true

RSpec.describe ModularRoutes::Route::Inner do
  subject(:inner_route) { described_class.new(http_method, action, options) }

  let(:http_method) { :post }
  let(:action) { :create }
  let(:options) { Hash[path: "something", other: "other"] }

  let(:expected_options) { Hash[to: "#{action}#call", other: "other"] }

  it "returns :to option" do
    expect(inner_route.args.last[:to]).to eq(expected_options[:to])
  end

  it "removes :path" do
    expect(inner_route.args.last).not_to include(:path)
  end

  it "returns args to be executed within resource(s) block" do
    # send(http_verb, :create, options)
    expect(inner_route.args).to eq([:post, :create, expected_options])
  end
end
