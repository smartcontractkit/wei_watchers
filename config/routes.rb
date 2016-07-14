Rails.application.routes.draw do
  root 'application#home'

  scope path: :api do
    get 'status' => 'application#status'

    get 'call' => 'call#show'
    resources :subscriptions, only: [:create]
    resource :ethereum, only: [] do
      get 'gas_price' => 'ethereum#gas_price'
      get 'get_transaction_count' => 'ethereum#get_transaction_count'
      post 'send_raw_transaction' => 'ethereum#send_raw_transaction'
    end
  end
end
