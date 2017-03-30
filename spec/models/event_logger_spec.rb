describe EventLogger, type: :model do

  describe ".perform" do
    let(:subscription) { factory_create :event_subscription }
    let(:eth) { EthereumClient.new }
    let(:account) { factory_create :account }
    let(:address) { account.address }
    let(:block_hash) { ethereum_txid }
    let(:block_number) { rand(1_000_000) }
    let(:data) { "0x#{SecureRandom.hex 32}" }
    let(:log_index) { rand(1_000_000) }
    let(:topics) { ["0x#{SecureRandom.hex 32}"] }
    let(:transaction_hash) { ethereum_txid }
    let(:transaction_index) { rand(1_000_000) }

    let(:params) do
      {
        address: address,
        blockHash: block_hash,
        blockNumber: uint_to_hex(block_number),
        data: data,
        logIndex: uint_to_hex(log_index),
        topics: topics,
        transactionHash: transaction_hash,
        transactionIndex: uint_to_hex(transaction_index),
      }
    end

    it "parses the hex values from Ethereum" do
      notification = EventLogger.perform(subscription.id, params)
      event = notification.event

      expect(event.account).to eq(account)
      expect(event.block_hash).to eq(block_hash)
      expect(event.block_number).to eq(block_number)
      expect(event.data).to eq(data)
      expect(event.log_index).to eq(log_index)
      expect(event.topic_ids).to eq(topics)
      expect(event.transaction_hash).to eq(transaction_hash)
      expect(event.transaction_index).to eq(transaction_index)
    end

    it "associates the new event with the filter passed in" do
      expect {
        EventLogger.perform(subscription.id, params)
      }.to change {
        subscription.reload.events.count
      }.by(+1)
    end

    context "when the account has not been recorded yet" do
      let(:address) { ethereum_address }

      it "creates a new account record" do
        expect {
          EventLogger.perform(subscription.id, params)
        }.to change {
          Account.count
        }.by(+1)

        expect(Account.last.address).to eq(address)
      end
    end

    context "when the event topic has not been recorded yet" do
      let(:address) { ethereum_address }
      let(:topics) { ["0x#{SecureRandom.hex 32}", "0x#{SecureRandom.hex 32}"] }

      it "creates a new account record" do
        expect {
          EventLogger.perform(subscription.id, params)
        }.to change {
          Topic.count
        }.by(topics.size)

        expect(Topic.last(topics.size).map(&:topic)).to eq(topics)
      end
    end

    context "when called for two different subscriptions" do
      let(:old_subscription) { factory_create :event_subscription }

      before do
        old_subscription = factory_create :event_subscription
        EventLogger.perform(old_subscription.id, params)
      end

      it "associates the new event with the filter passed in" do
        expect {
          EventLogger.perform(subscription.id, params)
        }.to change {
          subscription.reload.events.count
        }.by(+1)
      end
    end
  end

end
