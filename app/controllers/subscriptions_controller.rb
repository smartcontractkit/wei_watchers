class SubscriptionsController < ApiController

  def create
    address = params[:subscription][:address]
    end_at = Time.at params[:subscription][:address].to_i
    account = Account.find_or_create_by address: address

    if subscription = subscriber.subscriptions.create(account: account, end_at: end_at)
      render json: {
        address: address,
        acknowledged_at: Time.now.to_i,
        end_at: end_at.to_i
      }
    else
      render json: {errors: subscription.errors.full_messages}
    end
  end

end
