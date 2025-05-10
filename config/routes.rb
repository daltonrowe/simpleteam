Rails.application.routes.draw do
  root "home#index"

  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :teams do
    resources :seats
    resources :pending_seats
  end

  get "/dashboard", to: "dashboard#index"
  get "/dashboard/seats", to: "dashboard#seats"

  get "up" => "rails/health#show", as: :rails_health_check
end
