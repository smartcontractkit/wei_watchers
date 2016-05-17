class Subscriber < ActiveRecord::Base

  has_many :accounts, through: :subscriptions
  has_many :subscriptions, inverse_of: :subscriber

  validates :api_key, presence: true
  validates :notifier_id, presence: true
  validates :notifier_key, presence: true
  validates :notification_url, format: URI.regexp
  validates :xid, presence: true

  def self.notify(subscriber_id, info)
    SubscriberClient.delay.notify subscriber_id, info
  end

end
