class EventSubscriptionNotification < ActiveRecord::Base

  belongs_to :event, inverse_of: :event_subscription_notifications
  belongs_to :filter_config, inverse_of: :event_subscription_notifications

  validates :event, presence: true, uniqueness: { scope: [:filter_config] }
  validates :filter_config, presence: true

  after_create :log_event_with_subscriber


  private

  def log_event_with_subscriber
    filter_config.subscriber.event event_id
  end

end
