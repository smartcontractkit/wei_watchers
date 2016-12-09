class Subscriber < ActiveRecord::Base

  has_many :accounts, through: :subscriptions
  has_many :subscriptions, inverse_of: :subscriber
  has_many :filter_subscriptions, inverse_of: :subscriber
  has_many :filters, through: :filter_subscriptions

  validates :api_id, presence: true
  validates :api_key, presence: true
  validates :notifier_id, presence: true
  validates :notifier_key, presence: true
  validates :notification_url, format: URI.regexp

  before_validation :generate_credentials, on: :create

  def self.notify(subscriber_id, info)
    SubscriberClient.delay.notify subscriber_id, info
  end


  private

  def generate_credentials
    self.api_id ||= SecureRandom.urlsafe_base64(64)
    self.api_key ||= SecureRandom.urlsafe_base64(64)
    self.notifier_id ||= SecureRandom.urlsafe_base64(64)
    self.notifier_key ||= SecureRandom.urlsafe_base64(64)
  end

end
