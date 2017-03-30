class FilterReseter

  include HasEthereumClient

  def self.perform(subscription_id)
    subscription = EventSubscription.find subscription_id
    new(subscription).perform
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def perform
    update_filter
    record_past_events
  end


  private

  attr_reader :subscription

  def update_filter
    subscription.update_attributes!(filter: new_filter_id)
  end

  def record_past_events
    past_events.each do |event|
      EventLogger.perform(subscription.id, event)
    end
  end

  def past_events
    @past_events ||= ethereum.get_filter_logs(new_filter_id)
  end

  def new_filter_id
    @new_filter_id ||= subscription.new_on_chain_filter({
      fromBlock: ethereum.format_uint_to_hex(0)
    })
  end

end
