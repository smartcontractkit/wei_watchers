describe FiltersController, type: :controller do

  describe "#create" do
    let(:subscriber) { factory_create :subscriber }
    let(:filter_params) { { account: address, endAt: 1.year.from_now } }
    let(:address) { ethereum_address }


    context "when the subscriber does authenticate" do
      before { basic_auth_login subscriber }

      it "creates a new filter" do
        expect {
          post :create, filter_params
        }.to change {
          subscriber.filters.count
        }.by(+1).and change {
          Filter.count
        }.by(+1)
      end
    end

    context "when the subscriber does not authenticate" do
      it "does not create a new account" do
        expect {
          post :create, filter_params
        }.not_to change {
          Account.count
        }
      end

      it "does not create a new filter" do
        expect {
          post :create, filter_params
        }.not_to change {
          Filter.count
        }
      end
    end
  end

end
