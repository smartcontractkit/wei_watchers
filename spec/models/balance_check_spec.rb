describe BalanceCheck, type: :model do
  describe "#perform" do
    let(:checker) { BalanceCheck.new(account) }
    let(:past_balance) { rand(1_000_000_000) }
    let(:account) { factory_create :account, balance: past_balance }

    before do
      allow(account).to receive(:current_balance)
        .and_return(current_balance)
    end

    context "when the current amount is equal to the balance" do
      let(:current_balance) { past_balance }

      it "does not trigger a notification to subscribers" do
        expect(account).not_to receive(:notify_subscribers)

        checker.perform
      end

      it "does not change the account's balance" do
        expect {
          checker.perform
        }.not_to change {
          account.reload.balance
        }
      end
    end

    context "when the current amount is different than the balance" do
      let(:current_balance) { 0 }

      it "triggers notifications to subscribers" do
        expect(account).to receive(:notify_subscribers)
          .with({
            address: account.address,
            current_balance: current_balance.to_s,
            difference: (past_balance - current_balance).to_s,
            past_balance: past_balance.to_s,
          })

        checker.perform
      end

      it "updates the account's balance" do
        expect {
          checker.perform
        }.to change {
          account.balance
        }.from(past_balance).to(current_balance)
      end
    end
  end
end
