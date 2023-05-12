Rails.application.routes.draw do
  root to: "ports#index"
  devise_for :users

  resources :ports, only: [:show] do
    resources :favorites, only: :create
  end
end
