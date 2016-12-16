describe FilterCheck, type: :model do

  describe ".perform" do
    let(:subscription) { factory_create :event_subscription }
    let(:raw_event) { double :raw_event }

    it "logs whichever events it gets back from ethereum" do
      expect_any_instance_of(EthereumClient).to receive(:get_filter_changes)
        .with(subscription.filter)
        .and_return([raw_event])

      expect(EventLogger).to receive_message_chain(:delay, :perform)
        .with(subscription.id, raw_event)

      FilterCheck.perform subscription.id
    end
  end

end
