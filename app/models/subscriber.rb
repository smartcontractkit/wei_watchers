class Subscriber < ActiveRecord::Base

  has_many :balance_subscriptions, inverse_of: :subscriber
  has_many :accounts, through: :balance_subscriptions
  has_many :event_subscriptions, inverse_of: :subscriber
  has_many :filter_configs, through: :event_subscriptions

  validates :api_id, presence: true
  validates :api_key, presence: true
  validates :notifier_id, presence: true
  validates :notifier_key, presence: true
  validates :notification_url, format: URI.regexp

  before_validation :generate_credentials, on: :create

  def self.update_balance(subscriber_id, info)
    SubscriberClient.delay.account_balance subscriber_id, info
  end

  def event(event_id)
    client.delay.event event_id
  end


  private

  def generate_credentials
    self.api_id ||= SecureRandom.urlsafe_base64(64)
    self.api_key ||= SecureRandom.urlsafe_base64(64)
    self.notifier_id ||= SecureRandom.urlsafe_base64(64)
    self.notifier_key ||= SecureRandom.urlsafe_base64(64)
  end

  def client
    @client ||= SubscriberClient.new(self)
  end

end
