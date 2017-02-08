describe EventSubscription, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:end_at).when(Time.now) }
    it { is_expected.not_to have_valid(:end_at).when(nil) }

    it { is_expected.to have_valid(:filter_config).when(factory_create :filter_config) }
    it { is_expected.not_to have_valid(:filter_config).when(nil) }

    it { is_expected.to have_valid(:subscriber).when(factory_create :subscriber) }
    it { is_expected.not_to have_valid(:subscriber).when(nil) }

    it { is_expected.to have_valid(:xid).when(nil) }
  end

  describe "on create" do
    let(:account) { factory_create :account }
    let(:filter_id) { new_filter_id }
    let(:filter_config) { factory_create :filter_config, account: account }
    let(:subscription) { factory_build :event_subscription, filter_config: filter_config }

    it "creates a filter on the blockchain and saves its ID" do
      expect_any_instance_of(EthereumClient).to receive(:create_filter)
        .with({
          address: account.address,
          fromBlock: nil,
          toBlock: nil,
          topics: [],
        })
        .and_return(filter_id)

      expect {
        subscription.save
      }.to change {
        subscription.filter
      }.from(nil).to(filter_id)
    end

    it "generates an external ID" do
      expect {
        subscription.save
      }.to change {
        subscription.xid
      }.from(nil)
    end
  end

  describe ".current" do
    subject { EventSubscription.current }

    let!(:old_subscription) { factory_create :event_subscription, end_at: 1.minute.ago }
    let!(:new_subscription) { factory_create :event_subscription, end_at: 1.minute.from_now }

    it { is_expected.to include new_subscription }
    it { is_expected.not_to include old_subscription }
  end

  describe ".reset_current_filters" do
    let!(:old_subscription) { factory_create :event_subscription, end_at: 1.minute.ago }
    let!(:current_subscription) { factory_create :event_subscription, end_at: 1.minute.from_now }

    it "only resets the filters of current filters" do
      expect(FilterReseter).to receive(:perform)
        .with(current_subscription.id)

      EventSubscription.reset_current_filters
    end
  end

end
