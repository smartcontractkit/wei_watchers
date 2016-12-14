describe FilterSubscription, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:end_at).when(Time.now) }
    it { is_expected.not_to have_valid(:end_at).when(nil) }

    it { is_expected.to have_valid(:filter).when(factory_create :filter) }
    it { is_expected.not_to have_valid(:filter).when(nil) }

    it { is_expected.to have_valid(:subscriber).when(factory_create :subscriber) }
    it { is_expected.not_to have_valid(:subscriber).when(nil) }
  end

  describe ".current" do
    subject { FilterSubscription.current }

    let(:old_subscription) { factory_create :filter_subscription, end_at: 1.minute.ago }
    let(:new_subscription) { factory_create :filter_subscription, end_at: 1.minute.from_now }

    it { is_expected.to include new_subscription }
    it { is_expected.not_to include old_subscription }
  end

  describe "#reset_filter" do
    before do
      allow(EthereumClient).to receive(:post)
        .and_return(http_response body: {result: new_filter_id}.to_json)
    end

    let(:subscription) { factory_create :filter_subscription }
    let(:filter) { subscription.filter }

    it "creates a new filter id for the filter" do
      expect {
        subscription.reset_filter!
      }.to change {
        filter.reload.xid
      }
    end
  end

end
