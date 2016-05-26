class SubscriptionsController < ApiController

  def create
    address = params[:subscription][:address]
    end_at = Time.at params[:subscription][:end_at].to_i
    account = Account.find_or_create_by address: address

    if subscription = subscriber.subscriptions.create(account: account, end_at: end_at)
      success_response address: address, end_at: end_at.to_i
    else
      failure_response subscription.errors.full_messages
    end
  end

end
