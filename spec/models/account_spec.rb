describe Account, type: :model do
  describe "validations" do
    let!(:old_account) { factory_create :account }

    it { is_expected.to have_valid(:address).when("0x#{SecureRandom.hex(20).upcase}") }
    it { is_expected.not_to have_valid(:address).when(nil, '', old_account.address, "0x", SecureRandom.hex(20), "0x#{SecureRandom.hex 19}") }

    it { is_expected.to have_valid(:balance).when(0, 1, 32452345234562352462346246234624626535626432623462462) }
    it { is_expected.not_to have_valid(:balance).when(nil, -1, 0.1) }
  end

  describe "#notify_subscribers" do
    let(:params) { {foo: SecureRandom.hex} }
    let(:account) { factory_create :account }
    let(:subscriber1) { factory_create :subscriber }
    let(:subscriber2) { factory_create :subscriber }
    let!(:subscriber3) { factory_create :subscriber }
    let!(:subscriber4) { factory_create :subscriber }

    before do
      account.balance_subscriptions.create(subscriber: subscriber1, end_at: 1.minute.from_now)
      account.balance_subscriptions.create(subscriber: subscriber2, end_at: 1.second.ago)
      account.balance_subscriptions.create(subscriber: subscriber4, end_at: 1.minute.ago)
    end

    it "notifies only its accounts subscribers" do
      expect(Subscriber).to receive(:update_balance) do |subscriber_id, options|
        subscription = subscriber1.balance_subscriptions.first
        expect(options).to eq(params.merge(subscription: subscription.xid))
        expect(subscriber_id).to eq(subscriber1.id)
      end

      account.notify_subscribers(params)
    end
  end
end
