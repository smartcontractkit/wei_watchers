class SubscriptionReset

  include HasEthereumClient

  def self.perform(subscription_id)
    subscription = EventSubscription.find subscription_id
    new(subscription).perform
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def perform
    update_subscription
    record_past_events
  end


  private

  attr_reader :subscription

  def update_subscription
    subscription.update_attributes! last_block_height: 0
  end

  def record_past_events
    SubscriptionCheck.new(subscription, ethereum.current_block_height).perform
  end

end
