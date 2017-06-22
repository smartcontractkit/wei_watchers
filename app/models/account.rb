class Account < ActiveRecord::Base

  include HasEthereumClient

  has_many :balance_subscriptions, inverse_of: :account
  has_many :subscribers, through: :balance_subscriptions

  validates :address, format: /\A0x[0-9a-f]{40}\z/i, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def notify_subscribers(info)
    balance_subscriptions.current.each do |subscription|
      Subscriber.update_balance subscription.subscriber_id, info.merge({
        subscription: subscription.xid,
      })
    end
  end

  def current_balance
    ethereum.account_balance address
  end

end
