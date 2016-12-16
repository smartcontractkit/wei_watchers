describe EventSubscriptionNotification, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event).when(factory_create(:event)) }
    it { is_expected.not_to have_valid(:event).when(nil) }

    it { is_expected.to have_valid(:filter_config).when(factory_create(:filter_config)) }
    it { is_expected.not_to have_valid(:filter_config).when(nil) }

    context "when the event has already been recorded with that filter" do
      let(:old) { factory_create :event_subscription_notification }
      subject { EventSubscriptionNotification.new filter_config: old.filter_config }

      it { is_expected.not_to have_valid(:event).when(old.event) }
    end
  end

  describe "on create" do
    let(:event) { factory_create :event }
    let(:event_subscription) { factory_create :event_subscription }
    let(:filter_config) { event_subscription.filter_config }
    let(:event_filter) { EventSubscriptionNotification.new event: event, filter_config: filter_config }

    it "generates a notification for the filter's subscriber" do
      expect_any_instance_of(Subscriber).to receive(:event) do |subscriber, params|
        expect(subscriber).to eq(event_subscription.subscriber)
        expect(params).to eq(event.id)
      end

      event_filter.save
    end
  end

end
