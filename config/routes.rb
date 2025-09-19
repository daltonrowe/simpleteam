Rails.application.routes.draw do
  root "home#index"

  resource :session
  resource :registration, only: %i[new create]
  resource :user, only: %i[edit update] do
    get "confirm"
    post "reconfirm"
  end
  resources :passwords, param: :token

  resources :teams do
    resources :seats
    resources :pending_seats
    resources :statuses do
      post "draft"
    end

    post "api_key", to: "teams#create_api_key"

    get "data_store", to: "teams#data_store"
    get "data_store/:name", to: "teams#data_store_name", as: "data_name"
    get "data_store/:name/visualize", to: "teams#data_store_visualize", as: "data_visualize"

    resources :data, only: [ :index, :create, :destroy ] do
      collection do
        get :names
      end
    end
  end

  get "/dashboard/user", to: "dashboard#user"
  get "/dashboard", to: "dashboard#index"
  get "/dashboard/:team_id", to: "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :slack do
    get "create_team", to: "slack_installations#create", as: :create_team

    namespace :commands do
      post "simple_team", to: "simple_team#index", as: :handle
      post "interactivity", to: "interactivity#index", as: :interactivity
    end
  end
end
