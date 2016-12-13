class FiltersController < ApiController

  def create
    subscription = build_filter_subscription
    if subscription.save
      success_response id: subscription.xid
    else
      failure_response subscription.errors.full_messages
    end
  end


  private

  def build_filter_subscription
    subscriber.filter_subscriptions.build({
      end_at: params[:endAt],
      filter: Filter.new(filter_params),
    })
  end

  def filter_params
    {
      account: find_account,
      event_topics: event_topics,
      from_block: params[:fromBlock],
      to_block: params[:toBlock],
    }
  end

  def find_account
    if address = params[:account]
      Account.find_or_create_by address: address
    else
      nil
    end
  end

  def event_topics
    (params['topics'] || []).map do |topic|
      EventTopic.find_or_initialize_by topic: topic
    end
  end

end
