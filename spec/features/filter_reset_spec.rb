describe "logging events", type: :request do
  before { unstub_ethereum_calls }

  let(:subscriber) { factory_create :subscriber }
  let(:topic) { "0x#{bin_to_hex(Eth::Utils.keccak256 'Updated(bytes32)')}" }
  let(:subscription) { subscriber.reload.event_subscriptions.last }
  let(:oracle_data) { compiled_solidity('Oracle') }
  let(:write_address) { oracle_data['functionHashes']['update(bytes32)'] }
  let(:update_message) { 'Hi Mom!' }
  let(:contract_address) do
    tx = send_eth_tx(default_account, {
      data: oracle_data['bytecode'],
      gas_limit: (oracle_data['gasEstimates']['creation'].last * 10),
    })
    get_contract_address(tx.hash)
  end

  before do
    post('/api/event_subscriptions',
         {account: contract_address, topics: [topic], endAt: 1.year.from_now.to_i},
         basic_auth_login(subscriber, {}))

    update_tx = send_eth_tx(default_account, {
      data: "#{write_address}#{ethereum.format_bytes32_hex update_message}",
      to: contract_address,
    })
    wait_for_ethereum_confirmation update_tx.hash

    expect(subscription).to be_present

    expect {
      SubscriptionCheck.schedule_checks
      complete_all_current_background_jobs # generates job to create event
      complete_all_current_background_jobs # runs job create event
    }.to change {
      subscription.reload.events.count
    }.by(+1)
  end

  it "does not create duplicate events when run again" do
    expect {
      check_event_subscriptions
    }.not_to change {
      subscription.reload.events.count
    }
  end

  context "when reset and run again" do
    it "does not create duplicate events" do
      expect {
        reset_event_subscriptions
        check_event_subscriptions
      }.not_to change {
        subscription.reload.events.count
      }
    end
  end

  context "when reset and run again after a transaction is created" do
    before do
      update_tx = send_eth_tx(default_account, {
        data: "#{write_address}#{ethereum.format_bytes32_hex update_message}",
        to: contract_address,
      })
      wait_for_ethereum_confirmation update_tx.hash
    end

    it "does not create duplicate events" do
      expect {
        reset_event_subscriptions
        check_event_subscriptions
      }.to change {
        subscription.reload.events.count
      }.by(+1)
    end
  end
end
