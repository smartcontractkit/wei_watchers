class Filter < ActiveRecord::Base

  has_many :event_filters, inverse_of: :filter
  has_many :event_logs, through: :event_filters
  has_many :event_topics, through: :filter_topics
  has_one :filter_subscription, inverse_of: :filter
  has_many :filter_topics, inverse_of: :filter
  has_one :subscriber, through: :filter_subscription

  include HasEthereumClient

  belongs_to :account

  validates :from_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :to_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :xid, format: /\A0x[0-9a-f]{32}\z/

  before_validation :create_blockchain_filter, on: :create

  def topics
    event_topics.map(&:topic)
  end


  private

  def create_blockchain_filter
    self.xid ||= ethereum.create_filter({
      account: account.try(:address),
      fromBlock: from_block,
      toBlock: to_block,
      topics: topics,
    })
  end

end
