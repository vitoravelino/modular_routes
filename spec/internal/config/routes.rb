# frozen_string_literal: true

Rails.application.routes.draw do
  # Add your own routes here, or remove this file if you don't have need for it.
  modular_routes do
    # constraints
    resources :accounts, only: :show, constraints: { id: /\d+/ }

    scope constraints: { id: /\d+/ } do
      resources :papers, only: :show
    end

    # concerns
    concern :activatable do
      member do
        put :deactivate
        put :activate
      end
    end

    concern :commentable do
      resources :comments, only: :create
    end

    resources :books, only: [], concerns: :commentable

    resources :articles, concerns: [:activatable] do
      concerns :commentable
    end

    # plural
    resources :users do
      # collection inline
      delete :sign_out, on: :collection
      post :lock, on: :member
      get :previeww, on: :new

      # collection block
      collection do
        post :sign_in
      end

      member do
        get :status
      end

      new do
        get :preview
      end

      # nesting
      resource :profile
    end

    # singular
    resource :profile do
      # inline
      post :deactivate, on: :collection
      post :lock, on: :member
      get :previeww, on: :new

      # block
      collection do
        post :deactivatee
      end

      member do
        post :lockk
      end

      new do
        get :preview
      end

      # nesting
      resources :photos
    end

    # rename path
    resources :documents, only: [:index, :show], path: "/docs" do
      get :sent, on: :collection
      post :send, on: :member
    end

    # namespace
    namespace :v1 do
      resources :accounts, only: :create
      resources :documents, only: :index

      get :terms, to: "terms#show"
    end

    # switch namespace <-> module
    namespace :v1, module: :users do
      resources :users, module: :v1, only: :index
    end

    # only
    resources :products, only: :index
    resources :products, only: [:create]

    # except
    resources :boxes, except: :create
    resources :boxes, except: [:destroy, :edit, :new, :show, :update]

    # standalone shortcut
    get :about, to: "about#show"

    # standalone fallback
    get :terms, to: About::ShowController.action(:call)

    # scope
    scope :v2 do
      get :about, to: "about#show"
    end

    scope module: :v2 do
      get :privacy, to: "privacy#show"
    end

    # scope / standalone fallbacks
    scope controller: :fallback do
      get :fallback, action: :call
    end
  end

  # api mode
  modular_routes api_only: true do
    resources :books

    resource :book
  end

  # controller method
  modular_routes controller_method: :execute do
    resources :recipes
  end
end
