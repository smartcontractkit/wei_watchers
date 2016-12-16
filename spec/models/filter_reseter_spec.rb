describe FilterReseter, type: :model do

  describe ".perform" do
    before do
      allow(EthereumClient).to receive(:post)
        .and_return(http_response body: {result: new_filter_id}.to_json)

      expect_any_instance_of(EthereumClient).to receive(:get_filter_logs)
        .and_return(old_events)
    end

    let(:subscription) { factory_create :event_subscription }
    let(:filter) { subscription.filter }
    let(:old_events) { [] }

    it "creates a new filter ID for the filter" do
      expect {
        FilterReseter.perform(subscription.id)
      }.to change {
        filter.reload.xid
      }
    end

    context "when old events are found" do
      let(:old_event) { double :old_event }
      let(:old_events) { [old_event] }

      it "retries creating all past logs of the filter" do
        expect(EventLogger).to receive(:perform)
          .with(filter.id, old_event)

        FilterReseter.perform(subscription.id)
      end
    end
  end

end
