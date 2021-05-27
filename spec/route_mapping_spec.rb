# frozen_string_literal: true

RSpec.describe "Route Mapping", type: :routing do
  context "when plural resource" do
    it "maps :index routes" do
      expect(get: "/users").to route_to("users/index#call")
    end

    it "maps :create routes" do
      expect(post: "/users").to route_to("users/create#call")
    end

    it "maps :new routes" do
      expect(get: "/users/new").to route_to("users/new#call")
    end

    it "maps :show routes" do
      expect(get: "/users/1").to route_to(controller: "users/show", action: "call", id: "1")
    end

    it "maps :edit routes" do
      expect(get: "/users/1/edit").to route_to(controller: "users/edit", action: "call", id: "1")
    end

    it "maps :update routes (put)" do
      expect(put: "/users/1").to route_to(controller: "users/update", action: "call", id: "1")
    end

    it "maps :update routes (patch)" do
      expect(patch: "/users/1").to route_to(controller: "users/update", action: "call", id: "1")
    end

    it "maps :destroy routes" do
      expect(delete: "/users/1").to route_to(controller: "users/destroy", action: "call", id: "1")
    end
  end

  context "with custom routes" do
    it "maps :sign_in route" do
      expect(post: "/users/sign_in").to route_to("users/sign_in#call")
    end

    it "maps :sign_out route" do
      expect(delete: "/users/sign_out").to route_to("users/sign_out#call")
    end

    it "maps :get route" do
      expect(get: "/items/1/available").to route_to(controller: "items/available", action: "call", id: "1")
    end

    it "maps :deactive route" do
      expect(post: "/profile/deactivate").to route_to("profile/deactivate#call")
    end
  end

  context "when singular resource" do
    it "maps :create route" do
      expect(post: "/profile").to route_to("profile/create#call")
    end

    it "maps :show routes" do
      expect(get: "/profile").to route_to("profile/show#call")
    end

    it "maps :update routes (put)" do
      expect(put: "/profile").to route_to("profile/update#call")
    end

    it "maps :update routes (patch)" do
      expect(patch: "/profile").to route_to("profile/update#call")
    end

    it "maps :destroy routes" do
      expect(delete: "/profile").to route_to("profile/destroy#call")
    end
  end

  it "maps only specified actions" do
    expect(get: "/users/1").to route_to(controller: "users/show", action: "call", id: "1")
  end

  context "with custom resource path" do
    it "maps :create route" do
      expect(post: "/v1/accounts2").to route_to("v1/accounts/create#call")
    end

    it "maps :sent route" do
      expect(get: "/docs/sent").to route_to("documents/sent#call")
    end
  end

  context "with namespaces" do
    it "maps :index route (symbol)" do
      expect(get: "/v1/users").to route_to("v1/users/index#call")
    end

    it "maps :show route (array)" do
      expect(get: "/v1/users/1").to route_to(controller: "v1/users/show", action: "call", id: "1")
    end
  end
end
