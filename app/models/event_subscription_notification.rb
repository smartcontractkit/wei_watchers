class EventSubscriptionNotification < ActiveRecord::Base

  belongs_to :event, inverse_of: :event_subscription_notifications
  belongs_to :event_subscription, inverse_of: :event_subscription_notifications
  has_one :subscriber, through: :event_subscription

  validates :event, presence: true, uniqueness: { scope: [:event_subscription] }
  validates :event_subscription, presence: true

  after_create :log_event_with_subscriber


  private

  def log_event_with_subscriber
    subscriber.event event_id
  end

end
