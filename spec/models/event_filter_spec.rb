describe EventFilter, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event_log).when(factory_create(:event_log)) }
    it { is_expected.not_to have_valid(:event_log).when(nil) }

    it { is_expected.to have_valid(:filter).when(factory_create(:filter)) }
    it { is_expected.not_to have_valid(:filter).when(nil) }
  end

  describe "on create" do
    let(:event) { factory_create :event_log }
    let(:filter_subscription) { factory_create :filter_subscription }
    let(:filter) { filter_subscription.filter }
    let(:event_filter) { EventFilter.new event_log: event, filter: filter }

    it "generates a notification for the filter's subscriber" do
      expect_any_instance_of(Subscriber).to receive(:event_log) do |subscriber, params|
        expect(subscriber).to eq(filter_subscription.subscriber)
        expect(params).to eq(event.id)
      end

      event_filter.save
    end
  end

end
