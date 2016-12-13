describe SubscriberClient, type: :model do
  let(:subscriber) { factory_create :subscriber }
  let(:params) { {baz: SecureRandom.hex} }
  let(:client) { SubscriberClient.new subscriber }

  describe "#account_balance" do
    let(:response) { double success?: success, body: body }
    let(:body) { {}.to_json }

    before do
      expect(HTTParty).to receive(:post)
        .with("#{subscriber.notification_url}/account_balances", {
          basic_auth: {
            password: subscriber.notifier_key,
            username: subscriber.notifier_id,
          },
          body: params
        })
        .and_return(response)
    end

    context "when the response includes an acknowledged at time" do
      let(:success) { true }

      it "posts to the subscriber's notification URL" do
        expect {
          client.account_balance(params)
        }.not_to raise_error
      end
    end

    context "when the response does NOT include an acknowledged at time" do
      let(:success) { false }
      let(:body) { {errors: ['all of the errors']}.to_json }

      it "raises an error" do
        expect {
          client.account_balance(params)
        }.to raise_error 'Notification failure: ["all of the errors"]'
      end
    end
  end

  describe "#event_log" do
    let(:response) { double success?: success, body: body }
    let(:body) { {}.to_json }

    before do
      expect(HTTParty).to receive(:post)
        .with("#{subscriber.notification_url}/event_logs", {
          basic_auth: {
            password: subscriber.notifier_key,
            username: subscriber.notifier_id,
          },
          body: params
        })
        .and_return(response)
    end

    context "when the response includes an acknowledged at time" do
      let(:success) { true }

      it "posts to the subscriber's notification URL" do
        expect {
          client.event_log(params)
        }.not_to raise_error
      end
    end

    context "when the response does NOT include an acknowledged at time" do
      let(:success) { false }
      let(:body) { {errors: ['all of the errors']}.to_json }

      it "raises an error" do
        expect {
          client.event_log(params)
        }.to raise_error 'Notification failure: ["all of the errors"]'
      end
    end
  end

end
