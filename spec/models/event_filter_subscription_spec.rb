describe EventSubscriptionNotification, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event).when(factory_create(:event)) }
    it { is_expected.not_to have_valid(:event).when(nil) }

    it { is_expected.to have_valid(:filter).when(factory_create(:filter)) }
    it { is_expected.not_to have_valid(:filter).when(nil) }

    context "when the event has already been recorded with that filter" do
      let(:old) { factory_create :event_subscription_notification }
      subject { EventSubscriptionNotification.new filter: old.filter }

      it { is_expected.not_to have_valid(:event).when(old.event) }
    end
  end

  describe "on create" do
    let(:event) { factory_create :event }
    let(:filter_subscription) { factory_create :filter_subscription }
    let(:filter) { filter_subscription.filter }
    let(:event_filter) { EventSubscriptionNotification.new event: event, filter: filter }

    it "generates a notification for the filter's subscriber" do
      expect_any_instance_of(Subscriber).to receive(:event) do |subscriber, params|
        expect(subscriber).to eq(filter_subscription.subscriber)
        expect(params).to eq(event.id)
      end

      event_filter.save
    end
  end

end
