class EventSubscriptionsController < ApiController

  def create
    subscription = build_event_subscription
    if subscription.save
      success_response({
        id: subscription.xid,
        xid: subscription.xid,
      })
    else
      errors = subscription.errors.full_messages +
      filter_errors = subscription.filter ? subscription.filter.errors.full_messages : []
      failure_response (errors + filter_errors)
    end
  end


  private

  def build_event_subscription
    subscriber.event_subscriptions.build({
      end_at: Time.at(params[:endAt].to_i),
      filter_config: FilterConfig.new(filter_params),
    })
  end

  def filter_params
    {
      account: find_account,
      topics: topics,
      from_block: params[:fromBlock],
      to_block: params[:toBlock],
    }
  end

  def find_account
    if address = params[:account] || params[:address]
      Account.find_or_create_by address: address
    else
      nil
    end
  end

  def topics
    (params['topics'] || []).map do |topic|
      Topic.find_or_initialize_by topic: topic
    end
  end

end
