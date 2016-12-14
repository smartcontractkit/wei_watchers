class FilterReseter

  include HasEthereumClient

  def self.perform(subscription_id)
    subscription = FilterSubscription.find subscription_id
    new(subscription).perform
  end

  def initialize(subscription)
    @subscription = subscription
    @filter = subscription.filter
  end

  def perform
    update_filter
    record_past_events
  end


  private

  attr_reader :filter, :subscription

  def update_filter
    filter.update_attributes!(xid: new_filter_id)
  end

  def record_past_events
    past_events.each do |event|
      EventLogger.perform(filter.id, event)
    end
  end

  def past_events
    @past_events ||= ethereum.get_filter_logs(new_filter_id)
  end

  def new_filter_id
    @new_filter_id ||= filter.new_on_chain_filter(fromBlock: 0)
  end

end
