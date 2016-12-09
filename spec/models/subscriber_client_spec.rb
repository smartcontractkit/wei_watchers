describe SubscriberClient, type: :model do
  let(:subscriber) { factory_create :subscriber }
  let(:params) { {baz: SecureRandom.hex} }

  describe "#notify" do
    let(:response) { double success?: success, body: body }
    let(:notification_type) { 'accountBalance' }
    let(:body) { {}.to_json }

    before do
      expect(HTTParty).to receive(:post)
        .with(subscriber.notification_url, {
          basic_auth: {
            password: subscriber.notifier_key,
            username: subscriber.notifier_id,
          },
          body: params.merge({
              notificationType: notification_type
            })
        })
        .and_return(response)
    end

    context "when the response includes an acknowledged at time" do
      let(:success) { true }

      it "posts to the subscriber's notification URL" do
        expect {
          SubscriberClient.notify(subscriber.id, notification_type, params)
        }.not_to raise_error
      end
    end

    context "when the response does NOT include an acknowledged at time" do
      let(:success) { false }
      let(:body) { {errors: ['all of the errors']}.to_json }

      it "raises an error" do
        expect {
          SubscriberClient.notify(subscriber.id, notification_type, params)
        }.to raise_error 'Notification failure: ["all of the errors"]'
      end
    end
  end
end
