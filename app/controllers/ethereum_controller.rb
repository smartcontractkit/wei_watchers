class EthereumController < ApiController

  include HasEthereumClient

  def gas_price
    success_response wei: ethereum.gas_price.to_s
  end

end
