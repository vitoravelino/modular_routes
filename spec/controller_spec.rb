# frozen_string_literal: true

RSpec.describe "Controllers", type: :request do
  it "reaches action (plural resource)" do
    get users_path

    expect(response.body).to eq("Users::IndexController#call")
  end

  it "reaches action (single resource)" do
    get profile_path

    expect(response.body).to eq("Profile::ShowController#call")
  end

  it "reaches action (custom)" do
    post deactivate_profile_path

    expect(response.body).to eq("Profile::DeactivateController#call")
  end

  it "raises error (violated constraint)" do
    expect { account_path("d") }.to raise_error(ActionController::UrlGenerationError)
  end

  context "with namespace :v1" do
    it "reaches action (plural resource)" do
      get v1_users_path

      expect(response.body).to eq("V1::Users::IndexController#call")
    end
  end

  context "with namespace :v1 and inverted module" do
    it "reaches action (plural resource)" do
      post v1_users_path

      expect(response.body).to eq("Users::V1::CreateController#call")
    end
  end
end


