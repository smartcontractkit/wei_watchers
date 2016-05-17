describe Account, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:address).when("0x#{SecureRandom.hex 20}") }
    it { is_expected.not_to have_valid(:address).when(nil, '', "0x", SecureRandom.hex(20), "0x#{SecureRandom.hex 19}") }

    it { is_expected.to have_valid(:balance).when(0, 1, 32452345234562352462346246234624626535626432623462462) }
    it { is_expected.not_to have_valid(:balance).when(nil, -1, 0.1) }
  end

  describe "#notify_subscribers" do
    let(:params) { {foo: SecureRandom.hex} }
    let(:account) { factory_create :account }
    let(:subscriber1) { factory_create :subscriber }
    let(:subscriber2) { factory_create :subscriber }
    let!(:subscriber3) { factory_create :subscriber }

    before do
      account.subscribers = [subscriber1, subscriber2]
    end

    it "notifies only it's accounts subscribers" do
      expect(subscriber1).to receive(:notify)
        .with(params)
      expect(subscriber2).to receive(:notify)
        .with(params)
      expect(subscriber3).not_to receive(:notify)

      account.notify_subscribers(params)
    end
  end
end
