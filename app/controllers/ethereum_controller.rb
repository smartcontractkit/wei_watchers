class EthereumController < ApiController

  include HasEthereumClient

  def gas_price
    success_response wei: ethereum.gas_price.to_s
  end

  def send_raw_transaction
    response = ethereum.send_raw_transaction params[:hex]

    if response.txid
      success_response response.to_hash
    else
      failure_response response.error.to_json
    end
  end

  def get_transaction_count
    count = ethereum.get_transaction_count(params[:account])
    success_response count: count.to_s
  end

  def get_transaction
    tx = ethereum.get_transaction(params[:txid])
    success_response tx
  end

end
