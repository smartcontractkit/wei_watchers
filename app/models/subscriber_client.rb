class SubscriberClient

  include HttpClient

  def self.account_balance(subscriber_id, params)
    subscriber = Subscriber.find(subscriber_id)
    new(subscriber).account_balance(params)
  end

  def initialize(subscriber)
    @subscriber = subscriber
  end

  def account_balance(body)
    check_post_success '/account_balances', body
  end

  def event(id)
    event_notification = EventSubscriptionNotification.find(id)
    serializer = EventSubscriptionNotificationSerializer.new(event_notification)
    check_post_success '/events', serializer.attributes
  end


  private

  attr_reader :subscriber

  def check_post_success(path, body)
    url = "#{subscriber.notification_url}#{path}"
    response = post url, body

    unless response.success?
      json = JSON.parse(response.body)
      raise "Notification failure: #{json['errors']}"
    end
  end

  def http_client_auth_params
    {
      password: subscriber.notifier_key,
      username: subscriber.notifier_id,
    }
  end

end
