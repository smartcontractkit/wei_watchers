describe "logging events" do
  before { unstub_ethereum_calls }

  it "catches events" do
    oracle_data = compiled_solidity('Oracle')
    write_address = oracle_data['functionHashes']['update(bytes32)']
    read_address = oracle_data['functionHashes']['current()']
    updated_at_address = oracle_data['functionHashes']['updatedAt()']

    tx = send_eth_tx(default_account, {
      data: oracle_data['bytecode'],
      gas_limit: (oracle_data['gasEstimates']['creation'].last * 10),
    })
    contract_address = get_contract_address(tx.hash)

    filter = ethereum.create_filter address: contract_address
    expect(ethereum.get_filter_changes(filter)).to be_empty

    update_message = 'Hi Mom!'
    update_tx = send_eth_tx(default_account, {
      data: "#{write_address}#{ethereum.format_bytes32_hex update_message}",
      to: contract_address,
    })

    receipt = wait_for_ethereum_confirmation update_tx.hash
    current_hex = ethereum.call(data: read_address, to: contract_address).result
    current_value = ethereum.hex_to_utf8(current_hex)
    expect(current_value).to eq(update_message)

    ethereum.get_transaction_receipt update_tx.hash
    logs = ethereum.get_filter_changes filter

    expect(logs.size).to eq(2)
    topic = '0x' + Eth::Utils.keccak256('Updated(bytes32)').unpack('H*')[0]
    good_logs = logs.select {|log| log.topics.include? topic}
    expect(good_logs.size).to eq(1)
    logged_string = ethereum.hex_to_utf8 good_logs[0].data

    expect(logged_string).to eq(update_message)
  end
end
