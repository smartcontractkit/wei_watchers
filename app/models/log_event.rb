class LogEvent < ActiveRecord::Base

  belongs_to :account
  has_many :log_event_topics, inverse_of: :log_event
  has_many :event_topics, through: :log_event_topics

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
