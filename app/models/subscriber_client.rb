class SubscriberClient

  def self.notify(subscriber_id, params)
    subscriber = Subscriber.find(subscriber_id)
    new(subscriber).notify(params)
  end

  def initialize(subscriber)
    @subscriber = subscriber
  end

  def notify(body)
    response = post(body)

    unless response.success?
      json = JSON.parse(response.body)
      raise "Notification failure: #{json['errors']}"
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
    })
  end

end
