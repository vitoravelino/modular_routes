# frozen_string_literal: true

RSpec.describe "Route Mapping", type: :routing do
  context "when plural resource" do
    it "maps restful routes" do
      expect(get: "/users").to route_to("users/index#call")
      expect(post: "/users").to route_to("users/create#call")
      expect(get: "/users/new").to route_to("users/new#call")
      expect(get: "/users/1").to route_to(controller: "users/show", action: "call", id: "1")
      expect(get: "/users/1/edit").to route_to(controller: "users/edit", action: "call", id: "1")
      expect(put: "/users/1").to route_to(controller: "users/update", action: "call", id: "1")
      expect(patch: "/users/1").to route_to(controller: "users/update", action: "call", id: "1")
      expect(delete: "/users/1").to route_to(controller: "users/destroy", action: "call", id: "1")
    end

    it "maps collection routes" do
      expect(post: "/users/sign_in").to route_to("users/sign_in#call")
      expect(delete: "/users/sign_out").to route_to("users/sign_out#call")
    end

    it "maps member routes" do
      expect(get: "/users/1/status").to route_to(controller: "users/status", action: "call", id: "1")
      expect(post: "/users/1/lock").to route_to(controller: "users/lock", action: "call", id: "1")
    end

    it "maps new routes" do
      expect(get: "/users/new/preview").to route_to("users/preview#call")
      expect(get: "/users/new/previeww").to route_to("users/previeww#call")
    end
  end

  context "with nesting (plural -> singular)" do
    it "maps restful routes" do
      expect(post: "/users/1/profile").to route_to(controller: "users/profile/create", action: "call", user_id: "1")
      expect(delete: "/users/1/profile").to route_to(controller: "users/profile/destroy", action: "call", user_id: "1")
      expect(get: "/users/1/profile/edit").to route_to(controller: "users/profile/edit", action: "call", user_id: "1")
      expect(get: "/users/1/profile/new").to route_to(controller: "users/profile/new", action: "call", user_id: "1")
      expect(get: "/users/1/profile").to route_to(controller: "users/profile/show", action: "call", user_id: "1")
      expect(put: "/users/1/profile").to route_to(controller: "users/profile/update", action: "call", user_id: "1")
      expect(patch: "/users/1/profile").to route_to(controller: "users/profile/update", action: "call", user_id: "1")
    end
  end

  context "when singular resource" do
    it "maps restful routes" do
      expect(post: "/profile").to route_to("profile/create#call")
      expect(get: "/profile").to route_to("profile/show#call")
      expect(put: "/profile").to route_to("profile/update#call")
      expect(patch: "/profile").to route_to("profile/update#call")
      expect(delete: "/profile").to route_to("profile/destroy#call")
      expect(get: "/profile/new/preview").to route_to("profile/preview#call")
    end

    it "maps new routes" do
      expect(get: "/profile/new/preview").to route_to("profile/preview#call")
      expect(get: "/profile/new/previeww").to route_to("profile/previeww#call")
    end

    it "maps member routes" do
      expect(post: "/profile/lock").to route_to("profile/lock#call")
      expect(post: "/profile/lockk").to route_to("profile/lockk#call")
    end

    it "maps collection routes" do
      expect(post: "/profile/deactivate").to route_to("profile/deactivate#call")
      expect(post: "/profile/deactivatee").to route_to("profile/deactivatee#call")
    end
  end

  context "with nesting (singular -> plural)" do
    it "maps restful routes" do
      expect(get: "/profile/photos").to route_to("profile/photos/index#call")
      expect(post: "/profile/photos").to route_to("profile/photos/create#call")
      expect(get: "/profile/photos/new").to route_to("profile/photos/new#call")
      expect(get: "/profile/photos/1").to route_to(controller: "profile/photos/show", action: "call", id: "1")
      expect(get: "/profile/photos/1/edit").to route_to(controller: "profile/photos/edit", action: "call", id: "1")
      expect(put: "/profile/photos/1").to route_to(controller: "profile/photos/update", action: "call", id: "1")
      expect(patch: "/profile/photos/1").to route_to(controller: "profile/photos/update", action: "call", id: "1")
      expect(delete: "/profile/photos/1").to route_to(controller: "profile/photos/destroy", action: "call", id: "1")
    end
  end

  context "when renaming path" do
    it "maps routes" do
      expect(get: "/docs").to route_to("documents/index#call")
      expect(get: "/docs/1").to route_to(controller: "documents/show", action: "call", id: "1")
      expect(get: "/docs/sent").to route_to("documents/sent#call")
      expect(post: "/docs/1/send").to route_to(controller: "documents/send", action: "call", id: "1")
    end
  end

  context "with namespaces" do
    it "maps routes" do
      expect(get: "/v1/documents").to route_to("v1/documents/index#call")
      expect(post: "/v1/accounts").to route_to("v1/accounts/create#call")
    end
  end

  context "when :only" do
    it "maps routes (array)" do
      expect(post: "/products").to route_to("products/create#call")
    end

    it "maps routes (single)" do
      expect(get: "/products").to route_to("products/index#call")
    end
  end

  context "when :except" do
    it "maps non :except route" do
      expect(get: "/boxes").to route_to("boxes/index#call")
    end

    it "doesnt map routes (array)" do
      expect(post: "/boxes").not_to route_to("boxes/create#call")
    end

    it "doesnt map routes (single)" do
      expect(get: "/boxes/new").not_to route_to("boxes/new#call")
      expect(get: "/boxes/1").not_to route_to(controller: "boxes/show", action: "call", id: "1")
      expect(get: "/boxes/1/edit").not_to route_to(controller: "boxes/edit", action: "call", id: "1")
      expect(put: "/boxes/1").not_to route_to(controller: "boxes/update", action: "call", id: "1")
      expect(patch: "/boxes/1").not_to route_to(controller: "boxes/update", action: "call", id: "1")
      expect(delete: "/boxes/1").not_to route_to(controller: "boxes/destroy", action: "call", id: "1")
    end
  end

  context "when switching namespace <-> module names" do
    it "maps routes" do
      expect(get: "/v1/users").not_to route_to("users/v1/create#call")
    end
  end

  context "when standalone" do
    it "maps to namespaced controller route" do
      expect(get: "/about").to route_to("about/show#call")
    end
  end

  context "with scope" do
    it "maps routes (path scope)" do
      expect(get: "/v2/about").to route_to("about/show#call")
    end

    it "maps routes (module scope)" do
      expect(get: "/privacy").to route_to("v2/privacy/show#call")
    end
  end

  context "when api only" do
    it "doesnt map :edit, :new routes" do
      expect(get: "/books/1/edit").not_to route_to("books/edit#call")
      expect(get: "/book/new").not_to route_to("book/new#call")
    end
  end

  context "with concerns" do
    it "maps resources (command)" do
      expect(post: "/articles/1/comments").to route_to(
        controller: "articles/comments/create",
        action: "call",
        article_id: "1"
      )
    end

    it "maps resources (options)" do
      expect(post: "/books/1/comments").to route_to(controller: "books/comments/create", action: "call", book_id: "1")
    end

    it "maps member actions" do
      expect(put: "/articles/1/deactivate").to route_to(controller: "articles/deactivate", action: "call", id: "1")
      expect(put: "/articles/1/activate").to route_to(controller: "articles/activate", action: "call", id: "1")
    end
  end

  context "with controller_method" do
    it "maps_resources with controller_method execute" do
      expect(get: "/recipes").to route_to(controller: "recipes/index", action: "execute")
      expect(post: "/recipes").to route_to(controller: "recipes/create", action: "execute")
      expect(put: "/recipes/1").to route_to(controller: "recipes/update", action: "execute", id: "1")
      expect(get: "/recipes/1").to route_to(controller: "recipes/show", action: "execute", id: "1")
      expect(delete: "/recipes/1").to route_to(controller: "recipes/destroy", action: "execute", id: "1")
    end
  end
end
