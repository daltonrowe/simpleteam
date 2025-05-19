Rails.application.routes.draw do
  root "home#index"

  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :teams do
    resources :seats
    resources :pending_seats
    resources :statuses
  end

  get "/dashboard/user", to: "dashboard#user"
  get "/dashboard", to: "dashboard#index"
  get "/dashboard/:team_id", to: "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
