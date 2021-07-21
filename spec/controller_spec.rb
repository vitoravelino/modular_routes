# frozen_string_literal: true

RSpec.describe "Controllers", type: :request do
  it "raises error (violated constraint)" do
    expect { account_path("d") }.to raise_error(ActionController::UrlGenerationError)
    expect { paper_path("d") }.to raise_error(ActionController::UrlGenerationError)
  end
end
