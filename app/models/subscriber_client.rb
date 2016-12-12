class SubscriberClient

  def self.account_balance(subscriber_id, params)
    subscriber = Subscriber.find(subscriber_id)
    new(subscriber).notify(params)
  end

  def initialize(subscriber)
    @subscriber = subscriber
  end

  def account_balance(body)
    check_post_success '/account_balances', body
  end


  private

  attr_reader :subscriber

  def check_post_success(path, body)
    response = post path, body

    unless response.success?
      json = JSON.parse(response.body)
      raise "Notification failure: #{json['errors']}"
    end
  end

  def post(path, body)
    HTTParty.post("#{subscriber.notification_url}#{path}", {
      basic_auth: {
        password: subscriber.notifier_key,
        username: subscriber.notifier_id,
      },
      body: body
    })
  end

end
