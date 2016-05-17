class Account < ActiveRecord::Base

  include HasEthereumClient

  has_many :subscribers, through: :subscriptions
  has_many :subscriptions, inverse_of: :account

  validates :address, format: /\A0x[0-9a-f]{40}\z/
  validates :balance, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def notify_subscribers(info)
    subscribers.each do |subscriber|
      subscriber.notify info
    end
  end

  def current_balance
    ethereum.current_balance address
  end

end
