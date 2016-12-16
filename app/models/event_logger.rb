class EventLogger

  def self.perform(subscription_id, params)
    subscription = EventSubscription.find(subscription_id)
    new(subscription, params.with_indifferent_access).perform
  end

  def initialize(subscription, params)
    @subscription = subscription
    @params = params
  end

  def perform
    subscription.event_subscription_notifications.create({
      event: event
    })
  end


  private

  attr_reader :params, :subscription

  def account
    Account.find_or_create_by(address: params[:address])
  end

  def block_hash
    params[:blockHash]
  end

  def block_number
    ethereum.hex_to_int params[:blockNumber]
  end

  def data
    params[:data]
  end

  def log_index
    ethereum.hex_to_int params[:logIndex]
  end

  def topics
    params[:topics].map do |topic|
      Topic.find_or_create_by topic: topic
    end
  end

  def transaction_hash
    params[:transactionHash]
  end

  def transaction_index
    ethereum.hex_to_int params[:transactionIndex]
  end

  def event
    @event ||= (find_event || create_event)
  end

  def find_event
    Event.find_by({
      block_number: block_number,
      log_index: log_index,
    })
  end

  def create_event
    Event.create({
      account: account,
      block_hash: block_hash,
      block_number: block_number,
      data: data,
      log_index: log_index,
      topics: topics,
      transaction_hash: transaction_hash,
      transaction_index: transaction_index,
    })
  end

end
