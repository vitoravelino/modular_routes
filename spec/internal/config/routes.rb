# frozen_string_literal: true

Rails.application.routes.draw do
  # Add your own routes here, or remove this file if you don't have need for it.
  modular_route resources: :accounts, only: :show, constraints: { id: /\d+/ }

  modular_route resources: :users do
    post :sign_in, on: :collection
    delete :sign_out, on: :collection
  end

  modular_route resources: :items, only: [] do
    get :sent, on: :collection
    get :available, on: :member
  end

  modular_route resource: :profile do
    post :deactivate
  end

  modular_route resources: :documents, only: [], path: "/docs" do
    get :sent, on: :collection
  end

  namespace :v1 do
    modular_route resources: :accounts, only: :create, path: "/accounts2"
    modular_route resources: :users, only: :index
    modular_route resources: :users, only: [:show]
  end
end
