# frozen_string_literal: true

Rails.application.routes.draw do
  # Add your own routes here, or remove this file if you don't have need for it.
  modular_route resources: :accounts, only: :show, constraints: { id: /\d+/ }

  modular_route resources: :users, all: true do
    collection do
      post :sign_in
      delete :sign_out
    end
  end

  modular_route resources: :items do
    get :sent, on: :collection

    member do
      get :available
    end
  end

  modular_route resource: :profile, all: true do
    collection do
      post :deactivate
    end
  end

  modular_route resources: :documents, all: true, path: "/docs" do
    get :sent, on: :collection
  end

  namespace :v1 do
    modular_route resources: :accounts, only: :create, path: "/accounts2"
    modular_route resources: :users, only: :index
    modular_route resources: :users, only: [:show]
  end

  namespace :v1, module: :users do
    modular_route resources: :users, module: :v1, only: :create
  end
end
