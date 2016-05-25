class Account < ActiveRecord::Base

  include HasEthereumClient

  has_many :subscribers, through: :subscriptions
  has_many :subscriptions, inverse_of: :account

  validates :address, format: /\A0x[0-9a-f]{40}\z/, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def notify_subscribers(info)
    subscriptions.current.pluck(:subscriber_id).each do |subscriber_id|
      Subscriber.notify subscriber_id, info
    end
  end

  def current_balance
    ethereum.account_balance address
  end

end
