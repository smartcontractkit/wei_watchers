describe BalanceSubscriptionsController, type: :controller do
  describe "#create" do
    let(:subscriber) { factory_create :subscriber }
    let(:subscription_params) { {subscription: {address: address, end_at: 1.day.from_now.to_i}} }
    let(:address) { ethereum_address }

    context "when the account does not exist yet" do
      before { basic_auth_login subscriber }

      it "creates a new account" do
        expect {
          post :create, subscription_params
        }.to change {
          Account.find_by address: address
        }.from(nil)
      end

      it "creates a new subscription" do
        expect {
          post :create, subscription_params
        }.to change {
          subscriber.reload.balance_subscriptions.count
        }.by(+1)
      end
    end

    context "when the account does exist" do
      before { basic_auth_login subscriber }

      let!(:address) { factory_create(:account).address }

      it "does not create a new account" do
        expect {
          post :create, subscription_params
        }.not_to change {
          Account.count
        }
      end

      it "creates a new subscription" do
        expect {
          post :create, subscription_params
        }.to change {
          subscriber.balance_subscriptions.count
        }.by(+1)
      end
    end

    context "when the subscriber does not authenticate" do
      it "does not create a new account" do
        expect {
          post :create, subscription_params
        }.not_to change {
          Account.count
        }
      end

      it "does not create a new subscription" do
        expect {
          post :create, subscription_params
        }.not_to change {
          BalanceSubscription.count
        }
      end
    end
  end
end
