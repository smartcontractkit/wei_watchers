describe FilterCheck, type: :model do

  describe ".perform" do
    let(:subscription) { factory_create :filter_subscription }
    let(:filter) { subscription.filter }
    let(:raw_event_log) { double :raw_event_log }

    it "logs whichever events it gets back from ethereum" do
      expect_any_instance_of(EthereumClient).to receive(:get_filter_changes)
        .with(filter.xid)
        .and_return([raw_event_log])

      expect(EventLogger).to receive(:perform)
        .with(raw_event_log)

      FilterCheck.perform subscription.id
    end
  end

end
