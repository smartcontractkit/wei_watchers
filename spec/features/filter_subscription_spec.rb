describe "logging events", type: :request do
  before { unstub_ethereum_calls }

  let(:subscriber) { factory_create :subscriber }
  let(:topic) { "0x#{bin_to_hex(Eth::Utils.keccak256 'Updated(bytes32)')}" }

  it "reports events back to the subscriber" do
    oracle_data = compiled_solidity('Oracle')
    write_address = oracle_data['functionHashes']['update(bytes32)']

    tx = send_eth_tx(default_account, {
      data: oracle_data['bytecode'],
      gas_limit: (oracle_data['gasEstimates']['creation'].last * 10),
    })
    contract_address = get_contract_address(tx.hash)

    post('/api/event_subscriptions', {
      account: contract_address,
      topics: [topic],
      endAt: 1.year.from_now.to_i
    }, basic_auth_login(subscriber, {}))

    update_message = 'Hi Mom!'
    update_tx = send_eth_tx(default_account, {
      data: "#{write_address}#{ethereum.format_bytes32_hex update_message}",
      to: contract_address,
    })
    wait_for_ethereum_confirmation update_tx.hash

    subscription = subscriber.reload.event_subscriptions.last
    expect(subscription).to be_present

    expect {
      check_event_subscriptions
    }.to change {
      subscription.reload.events.count
    }.by(+1)

    event = Event.last
    expect(SubscriberClient).to receive(:post)
      .with("#{subscriber.notification_url}/events", {
        basic_auth: {
          password: subscriber.notifier_key,
          username: subscriber.notifier_id,
        },
        body: {
          address: event.address,
          blockHash: event.block_hash,
          blockNumber: event.block_number,
          data: event.data,
          logIndex: event.log_index,
          topics: event.topic_ids,
          subscription: event.event_subscription_notifications.first.subscription_xid,
          transactionHash: event.transaction_hash,
          transactionIndex: event.transaction_index,
        }
      }).and_return(http_response)
    complete_all_current_background_jobs # runs job to update subscriber
  end
end
