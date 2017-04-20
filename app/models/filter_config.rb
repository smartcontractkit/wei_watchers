class FilterConfig < ActiveRecord::Base

  include HasEthereumClient

  belongs_to :account
  has_many :events, through: :event_subscription_notifications
  has_many :event_subscription_notifications, inverse_of: :filter_config
  has_many :topics, through: :filter_topics
  has_one :event_subscription, inverse_of: :filter_config
  has_many :filter_topics, inverse_of: :filter_config
  has_one :subscriber, through: :event_subscription

  validates :from_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :to_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }

  def address
    account.address if account.present?
  end

  def topic_ids
    topics.map(&:topic)
  end

  def params
    {
      address: address,
      fromBlock: from_block_param,
      toBlock: to_block_param,
      topics: topic_ids,
    }
  end


  private

  def from_block_param
    "0x" + ethereum.format_uint_to_hex(from_block.to_i)
  end

  def to_block_param
    if to_block.present?
      "0x" + ethereum.format_uint_to_hex(to_block)
    end
  end

end
