class Subscriber < ActiveRecord::Base

  has_many :accounts, through: :account_subscribers
  has_many :account_subscribers, inverse_of: :subscriber

  validates :api_key, presence: true
  validates :notifier_id, presence: true
  validates :notifier_key, presence: true
  validates :notification_url, format: URI.regexp
  validates :xid, presence: true

end
