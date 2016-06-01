Rails.application.routes.draw do
  root 'application#home'

  scope path: :api do
    resources :subscriptions, only: [:create]
    resource :ethereum, only: [] do
      get 'gas_price' => 'ethereum#gas_price'
      post 'send_raw_transaction' => 'ethereum#send_raw_transaction'
    end
  end
end
