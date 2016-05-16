describe Subscription, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:account).when(Account.new) }
    it { is_expected.not_to have_valid(:account).when(nil) }

    it { is_expected.to have_valid(:subscriber).when(Subscriber.new) }
    it { is_expected.not_to have_valid(:subscriber).when(nil) }
  end
end
