describe "logging events", type: :request do before { unstub_ethereum_calls }

  let(:subscriber) { factory_create :subscriber }
  let(:topic) { "0x#{bin_to_hex(Eth::Utils.keccak256 'Updated(bytes32)')}" }

  it "reports events back to the subscriber" do
    oracle_data = compiled_solidity('Oracle')
    write_address = oracle_data['functionHashes']['update(bytes32)']

    tx = send_eth_tx(default_account, {
      data: hex_to_bin(oracle_data['bytecode']),
      gas_limit: (oracle_data['gasEstimates']['creation'].last * 10),
    })
    contract_address = get_contract_address(tx.hash)

    post('/api/filters',
         {account: contract_address, topics: [topic], endAt: 1.year.from_now.to_i},
         basic_auth_login(subscriber, {}))

    update_message = 'Hi Mom!'
    update_tx = send_eth_tx(default_account, {
      data: hex_to_bin("#{write_address}#{ethereum.format_bytes32_hex update_message}"),
      to: contract_address,
    })
    wait_for_ethereum_confirmation update_tx.hash

    subscription = subscriber.reload.filter_subscriptions.last
    expect(subscription).to be_present

    expect {
      FilterCheck.schedule_checks
      complete_all_current_background_jobs # generates job to create event
      complete_all_current_background_jobs # runs job create event
    }.to change {
      subscription.reload.event_logs.count
    }.by(+1)

    event_log = EventLog.last
    expect(HTTParty).to receive(:post)
      .with("#{subscriber.notification_url}/event_logs", {
        basic_auth: {
          password: subscriber.notifier_key,
          username: subscriber.notifier_id,
        },
        body: {
          address: event_log.address,
          blockHash: event_log.block_hash,
          blockNumber: event_log.block_number,
          data: event_log.data,
          logIndex: event_log.log_index,
          topics: event_log.topics,
          transactionHash: event_log.transaction_hash,
          transactionIndex: event_log.transaction_index,
        }
      }).and_return(http_response)
    complete_all_current_background_jobs # runs job to update subscriber
  end
end
