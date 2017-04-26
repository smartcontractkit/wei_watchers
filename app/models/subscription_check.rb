class SubscriptionCheck

  include HasEthereumClient

  def self.schedule_checks(current_block = nil)
    current_block ||= EthereumClient.new.current_block_height

    EventSubscription.current.pluck(:id).uniq.each do |subscription_id|
      delay.perform subscription_id, current_block
    end
  end

  def self.perform(id, current_block = nil)
    subscription = EventSubscription.find(id)
    new(subscription, current_block).perform
  end

  def initialize(subscription, current_block = nil)
    @subscription = subscription
    @current_block = current_block
  end

  def perform
    new_logs.each do |log|
      EventLogger.delay.perform(subscription.id, log)
    end

    update_subscription_block_height
  end


  private

  attr_reader :current_block, :subscription

  def new_logs
    @new_logs ||= ethereum.get_logs(subscription.filter_params).result
  end

  def update_subscription_block_height
    if current_block.present?
      subscription.update_attributes! last_block_height: current_block
    end
  end

end
