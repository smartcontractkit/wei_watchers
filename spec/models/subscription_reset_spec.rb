describe SubscriptionReset, type: :model do

  describe ".perform" do
    let(:current_block_height) { 7_777_777 }
    let(:subscription) { factory_create :event_subscription, last_block_height: 333 }
    let(:old_events) { [] }

    before do
      allow_any_instance_of(EthereumClient).to receive(:current_block_height)
        .and_return(current_block_height)

      expect_any_instance_of(EthereumClient).to receive(:get_logs)
        .with(subscription.filter_params.merge({
          fromBlock: "0x#{ethereum.format_int_to_hex 0}"
        }))
        .and_return(double result: old_events)
    end

    it "sets the block height to the current height" do
      expect {
        SubscriptionReset.perform(subscription.id)
      }.to change {
        subscription.reload.last_block_height
      }.to(current_block_height)
    end

    context "when old events are found" do
      let(:old_event) { double :old_event }
      let(:old_events) { [old_event] }

      it "retries creating all past logs of the filter" do
        expect(EventLogger).to receive_message_chain(:delay, :perform)
          .with(subscription.id, old_event)

        SubscriptionReset.perform(subscription.id)
      end
    end
  end

end
