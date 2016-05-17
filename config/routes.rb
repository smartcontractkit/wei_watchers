Rails.application.routes.draw do
  root 'application#home'

  scope path: :api do
    resources :subscriptions, only: [:create]
  end
end
