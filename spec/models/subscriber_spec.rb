describe Subscriber, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:notification_url).when('https://example.com/api/notifiy') }
    it { is_expected.not_to have_valid(:notification_url).when(nil, '', 'blah.com') }

    it { is_expected.to have_valid(:api_id).when(SecureRandom.hex) }

    it { is_expected.to have_valid(:api_key).when(SecureRandom.hex) }

    it { is_expected.to have_valid(:notifier_id).when(SecureRandom.hex) }

    it { is_expected.to have_valid(:notifier_key).when(SecureRandom.hex) }
  end

  describe "on create" do
    let(:subscriber) { factory_build :subscriber }

    it "creates new keys" do
      expect {
        subscriber.save
      }.to change {
        subscriber.api_id
      }.from(nil).and change {
        subscriber.api_key
      }.from(nil).and change {
        subscriber.notifier_id
      }.from(nil).and change {
        subscriber.notifier_key
      }.from(nil)
    end
  end

  describe ".notify" do
    let(:subscriber) { factory_create :subscriber }
    let(:params) { {bar: SecureRandom.hex} }

    it "sends a notification to subscriber" do
      expect(SubscriberClient).to receive_message_chain(:delay, :notify)
        .with(subscriber.id, 'accountBalance', params)

      Subscriber.notify subscriber.id, 'accountBalance', params
    end
  end
end
