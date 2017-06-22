describe BalanceCheck, type: :model do
  describe ".schedule_checks" do
    let(:account) { factory_create :account }
    let(:old_account) { factory_create :account }
    let!(:old_subscription1) { factory_create :balance_subscription, account: account, end_at: 1.day.ago }
    let!(:old_subscription2) { factory_create :balance_subscription, account: old_account, end_at: 1.day.ago }
    let!(:current_subscription1) { factory_create :balance_subscription, account: account, end_at: 1.day.from_now }
    let!(:current_subscription2) { factory_create :balance_subscription, account: account, end_at: 1.day.from_now }

    it "schedules a check for every subscription that is still open" do
      check_count = 0
      expect(BalanceCheck).to receive_message_chain(:delay, :perform)
        .with(account.id) do |id|
          check_count += 1
        end

      BalanceCheck.schedule_checks
      expect(check_count).to eq(1)
    end
  end

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
            currentBalance: current_balance.to_s,
            difference: (past_balance - current_balance).to_s,
            pastBalance: past_balance.to_s,
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
