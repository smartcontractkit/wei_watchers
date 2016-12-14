class EventLogSerializer < ActiveModel::Serializer

  attributes :address, :blockHash, :blockNumber, :data,
    :logIndex, :topics, :transactionHash, :transactionIndex

  def blockHash
    object.block_hash
  end

  def blockNumber
    object.block_number
  end

  def logIndex
    object.log_index
  end

  def transactionHash
    object.transaction_hash
  end

  def transactionIndex
    object.transaction_index
  end

end
