describe SubscriberClient, type: :model do
  let(:subscriber) { factory_create :subscriber }
  let(:params) { {baz: SecureRandom.hex} }

  describe ".notify" do
    context "when the response includes an acknowledged at time" do
      let(:response) { double body: {acknowledged_at: Time.now.to_i}.to_json }

      it "posts to the subscriber's notification URL" do
        expect(HTTParty).to receive(:post)
          .with(subscriber.notification_url, {
            basic_auth: {
              password: subscriber.notifier_key,
              username: subscriber.notifier_id,
            },
            body: params
          })
          .and_return(response)

        expect {
          SubscriberClient.notify(subscriber.id, params)
        }.not_to raise_error
      end
    end

    context "when the response does NOT include an acknowledged at time" do
      let(:response) { double body: {errors: '["all of the errors"]'}.to_json }

      it "posts to the subscriber's notification URL" do
        expect(HTTParty).to receive(:post)
          .with(subscriber.notification_url, instance_of(Hash))
          .and_return(response)

        expect {
          SubscriberClient.notify(subscriber.id, params)
        }.to raise_error 'Subscriber did not acknowledge: ["all of the errors"]'
      end
    end
  end

end
