describe EventSubscriptionsController, type: :controller do

  describe "#create" do
    before do
      allow(EthereumClient).to receive(:post)
        .and_return(http_response body: {result: new_filter_id}.to_json)
    end

    let(:address) { ethereum_address }
    let(:subscriber) { factory_create :subscriber }
    let(:topics) { nil }
    let(:filter_params) do
      {
        address: address,
        endAt: 1.year.from_now,
        topics: topics,
      }
    end

    context "when the subscriber does authenticate" do
      before { basic_auth_login subscriber }

      it "creates a new filter" do
        expect {
          post :create, filter_params
        }.to change {
          subscriber.filter_configs.count
        }.by(+1).and change {
          FilterConfig.count
        }.by(+1)
      end

      it "responds with an identifier for the filter config" do
        post :create, filter_params

        expect(json_response['id']).to eq(EventSubscription.last.xid)
        expect(json_response['xid']).to eq(EventSubscription.last.xid)
      end

      context "when topics are included" do
        let!(:old_topic) { factory_create :topic }
        let(:topics) { [new_filter_topic, old_topic.topic] }

        it "creates new topics for the new topic records" do
          expect {
            post :create, filter_params
          }.to change {
            Topic.count
          }.by(+1)
        end

        it "associates with the old topics" do
          post :create, filter_params

          expect(FilterConfig.last.topics).to include(old_topic)
        end
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
          FilterConfig.count
        }
      end
    end
  end

end
