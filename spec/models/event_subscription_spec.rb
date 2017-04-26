describe EventSubscription, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:end_at).when(Time.now) }
    it { is_expected.not_to have_valid(:end_at).when(nil) }

    it { is_expected.to have_valid(:filter_config).when(factory_create :filter_config) }
    it { is_expected.not_to have_valid(:filter_config).when(nil) }

    it { is_expected.to have_valid(:subscriber).when(factory_create :subscriber) }
    it { is_expected.not_to have_valid(:subscriber).when(nil) }
  end

  describe "on create" do
    let(:subscription) { factory_build :event_subscription }

    it "checks for past events that it may already have missed" do
      expect(SubscriptionCheck).to receive_message_chain(:delay, :perform) do |id|
        expect(id).to eq(subscription.id)
      end

      subscription.save
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
      expect(SubscriptionReset).to receive(:perform)
        .with(current_subscription.id)

      EventSubscription.reset_current_filters
    end
  end

  describe "#filter_params" do
    let(:filter) { factory_create :filter_config }
    let(:subscription) { factory_create :event_subscription, filter_config: filter }

    it "returns all of the filter details" do
      params = subscription.filter_params

      expect(params[:address]).to eq(filter.address)
      expect(params[:fromBlock]).to eq("0x#{ethereum.format_int_to_hex subscription.last_block_height}")
      expect(params[:toBlock]).to eq(filter.to_block)
      expect(params[:topics]).to eq(filter.topic_ids)
    end
  end

end
