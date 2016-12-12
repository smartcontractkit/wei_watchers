class EventLogger

  def self.perform(params)
    new(params.with_indifferent_access).perform
  end

  def initialize(params)
    @params = params
  end

  def perform
    LogEvent.create!({
      account: account,
      block_hash: block_hash,
      block_number: block_number,
      data: data,
      log_index: log_index,
      event_topics: event_topics,
      transaction_hash: transaction_hash,
      transaction_index: transaction_index,
    })
  end


  private

  attr_reader :params

  def account
    Account.find_or_create_by(address: params[:address])
  end

  def block_hash
    params[:blockHash]
  end

  def block_number
    ethereum.hex_to_int params[:blockNumber]
  end

  def data
    params[:data]
  end

  def log_index
    ethereum.hex_to_int params[:logIndex]
  end

  def event_topics
    params[:topics].map do |topic|
      EventTopic.find_or_create_by topic: topic
    end
  end

  def transaction_hash
    params[:transactionHash]
  end

  def transaction_index
    ethereum.hex_to_int params[:transactionIndex]
  end

end
