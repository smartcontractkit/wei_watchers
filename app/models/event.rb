class Event < ActiveRecord::Base

  belongs_to :account
  has_many :event_subscription_notifications, inverse_of: :event
  has_many :event_topics, inverse_of: :event
  has_many :topics, through: :event_topics
  has_many :event_subscriptions, through: :event_subscription_notifications

  validates :account, presence: true
  validates :block_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :block_number, numericality: { greater_than_or_equal_to: 0 }
  validates :log_index, numericality: { greater_than_or_equal_to: 0 },
    uniqueness: { scope: :block_number }
  validates :transaction_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :transaction_index, numericality: { greater_than_or_equal_to: 0 }

  def topic_ids
    topics.map(&:topic)
  end

  def address
    account.address
  end

end
