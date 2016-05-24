class SubscriberClient

  def self.notify(subscriber_id, params)
    subscriber = Subscriber.find(subscriber_id)
    new(subscriber).notify(params)
  end

  def initialize(subscriber)
    @subscriber = subscriber
  end

  def notify(body)
    json = JSON.parse(post(body))

    if json['acknowledged_at'].blank?
      raise "Subscriber did not acknowledge: #{json['errors']}"
    end
  end


  private

  attr_reader :subscriber

  def post(body)
    HTTParty.post(subscriber.notification_url, {
      basic_auth: {
        password: subscriber.notifier_key,
        username: subscriber.notifier_id,
      },
      body: body
    }).body
  end

end
