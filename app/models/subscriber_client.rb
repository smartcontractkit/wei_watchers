class SubscriberClient

  def self.notify(subscriber_id, type, params)
    subscriber = Subscriber.find(subscriber_id)
    new(subscriber).notify(type, params)
  end

  def initialize(subscriber)
    @subscriber = subscriber
  end

  def notify(notification_type, body)
    response = post body.merge({
      notificationType: notification_type,
    })

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
