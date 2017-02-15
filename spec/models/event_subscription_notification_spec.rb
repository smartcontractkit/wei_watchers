describe EventSubscriptionNotification, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event).when(factory_create(:event)) }
    it { is_expected.not_to have_valid(:event).when(nil) }

    it { is_expected.to have_valid(:event_subscription).when(factory_create :event_subscription) }
    it { is_expected.not_to have_valid(:event_subscription).when(nil) }

    context "when the event has already been recorded with that filter" do
      let(:old) { factory_create :event_subscription_notification }
      subject { EventSubscriptionNotification.new event_subscription: old.event_subscription }

      it { is_expected.not_to have_valid(:event).when(old.event) }
    end
  end

  describe "on create" do
    let(:event) { factory_create :event }
    let(:event_subscription) { factory_create :event_subscription }
    let(:event_filter) { EventSubscriptionNotification.new event: event, event_subscription: event_subscription }

    it "generates a notification for the filter's subscriber" do
      expect_any_instance_of(Subscriber).to receive(:event) do |subscriber, params|
        expect(subscriber).to eq(event_subscription.subscriber)
        expect(params).to eq(event_filter.id)
      end

      event_filter.save
    end
  end

end
