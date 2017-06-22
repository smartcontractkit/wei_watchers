describe BalanceSubscription, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:account).when(Account.new) }
    it { is_expected.not_to have_valid(:account).when(nil) }

    it { is_expected.to have_valid(:subscriber).when(Subscriber.new) }
    it { is_expected.not_to have_valid(:subscriber).when(nil) }

    it { is_expected.to have_valid(:end_at).when(Time.now) }
    it { is_expected.not_to have_valid(:end_at).when(nil) }
  end

  describe "on create" do
    let(:subscription) { factory_build :balance_subscription }

    it "generates a uuid for the subscription" do
      expect {
        subscription.save
      }.to change {
        subscription.xid
      }.from(nil)
    end
  end
end
