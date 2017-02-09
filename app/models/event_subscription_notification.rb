class EventSubscriptionNotification < ActiveRecord::Base

  belongs_to :event, inverse_of: :event_subscription_notifications
  belongs_to :event_subscription, inverse_of: :event_subscription_notifications
  has_one :subscriber, through: :event_subscription

  validates :event, presence: true, uniqueness: { scope: [:event_subscription] }
  validates :event_subscription, presence: true

  after_create :log_event_with_subscriber

  def address
    event.address
  end

  def block_hash
    event.block_hash
  end

  def block_number
    event.block_number
  end

  def data
    event.data
  end

  def log_index
    event.log_index
  end

  def subscription_xid
    event_subscription.xid
  end

  def topic_ids
    event.topic_ids
  end

  def transaction_hash
    event.transaction_hash
  end

  def transaction_index
    event.transaction_index
  end


  private

  def log_event_with_subscriber
    subscriber.event id
  end

end
