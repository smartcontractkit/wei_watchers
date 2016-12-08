class Filter < ActiveRecord::Base

  include HasEthereumClient

  belongs_to :account

  validates :from_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :to_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :xid, format: /\A0x[0-9a-f]{64}\z/

  before_validation :create_blockchain_filter, on: :create

  def topics=(new_topics = [])
    self.topics_json = Array.wrap(new_topics).to_json
    topics
  end

  def topics
    if topics_json.present?
      JSON.parse(topics_json)
    else
      []
    end
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
