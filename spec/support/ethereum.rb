module SpecHelpers

  def ethereum
    @ethereum ||= EthereumClient.new
  end

  def default_account
    @default_account ||= Eth::Key.new({
      priv: '721b3cb22661758e0a4b9d587cbe5ce672257cde7567bc7cd6640279e686391a'
    })
  end

  def default_address
    default_account.to_address
  end

  def compiled_solidity(name)
    HTTParty.post('https://solc.smartcontract.com/api/compile', body: {
      solidity: File.read("spec/fixtures/ethereum/#{name}.sol")
    })['contracts'][name]
  end

  def ethereum_txid
    "0x#{SecureRandom.hex(32)}"
  end

  def ethereum_address
    "0x#{SecureRandom.hex(20)}"
  end

  def ethereum_gas_price
    "0x#{SecureRandom.hex(5)}"
  end

  def new_filter_id
    "0x#{SecureRandom.hex(16)}"
  end

  def new_filter_topic
    "0x#{SecureRandom.hex(32)}"
  end

  def ethereum_create_transaction_response(options = {})
    options.with_indifferent_access
    {
      "id" => (options[:id] || HttpClient.random_id),
      "jsonrpc" => "2.0",
      "result" => (options[:result] || options[:txid] || ethereum_txid)
    }
  end

  def ethereum_receipt_response(options = {})
    options.with_indifferent_access
    hashie({
      id: 7357,
      jsonrpc: '2.0',
      result: {
        blockHash: ethereum_txid,
        blockNumber: '0x7357',
        contractAddress: (options[:contract_address] || ethereum_address),
        cumulativeGasUsed: ethereum_gas_price,
        gasUsed: ethereum_gas_price,
        logs: [{}],
        transactionHash: (options[:txid] || options[:transaction_hash] || ethereum_txid),
        transactionIndex:  '0x1',
      }
    })
  end

  def ethereum_contract_factory(options = {})
    EthereumContract.create({
      account: options[:account],
      address: options[:address],
      template: options[:template],
    })
  end

  def ethereum_oracle_factory(options = {})
    oracle_contract_factory.terms.first.expectation.tap do |oracle|
      oracle.ethereum_contract = ethereum_contract_factory
      oracle.update_attributes options
    end
  end

  def ethereum
    @ethereum ||= EthereumClient.new
  end

  def wait_for_ethereum_confirmation(txid)
    raise "No TXID to wait for!" if txid.blank?
    average_block_time = 17
    try_rate = 4.0
    buffer = 6

    receipt = nil
    ((average_block_time * buffer) * try_rate).to_i.times do
      block_height = ethereum.current_block_height
      receipt ||= ethereum.get_transaction_receipt(txid)

      if receipt && receipt.blockNumber
        tx_block_number ||= ethereum.hex_to_int(receipt.blockNumber)
        break if (tx_block_number && (block_height.to_i >= tx_block_number.to_i))
      end
      sleep (1 / try_rate)
    end
    receipt
  end

  def get_contract_address(txid)
    wait_for_ethereum_confirmation(txid).contractAddress
  end

  def send_eth_tx(account, details)
    tx = Eth::Tx.new({
      data: '',
      gas_limit: 100_000,
      gas_price: 2_100,
      nonce: ethereum.get_transaction_count(account.to_address),
      value: 0,
    }.merge(details))
    tx.sign account
    ethereum.send_raw_transaction tx.hex
    tx
  end
end
