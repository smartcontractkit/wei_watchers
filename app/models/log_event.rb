class LogEvent < ActiveRecord::Base

  belongs_to :account

  validates :account, presence: true
  validates :block_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :block_number, numericality: { greater_than_or_equal_to: 0 }
  validates :log_index, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_hash, format: /\A0x[0-9a-f]{64}\z/
  validates :transaction_index, numericality: { greater_than_or_equal_to: 0 }

end
