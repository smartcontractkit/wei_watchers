class EventLog < ActiveRecord::Base

  belongs_to :account
  has_many :event_log_topics, inverse_of: :event_log
  has_many :event_topics, through: :event_log_topics

  validates :account, presence: true
  validates :block_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :block_number, numericality: { greater_than_or_equal_to: 0 }
  validates :log_index, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :transaction_index, numericality: { greater_than_or_equal_to: 0 }

  def topics
    event_topics.map(&:topic)
  end

end
