class BalanceSubscription < ActiveRecord::Base

  belongs_to :account, inverse_of: :balance_subscriptions
  belongs_to :subscriber, inverse_of: :balance_subscriptions

  validates :account, presence: true
  validates :end_at, presence: true
  validates :subscriber, presence: true
  validates :xid, presence: true

  before_validation :set_up, on: :create

  scope :current, -> { where "end_at > ?", Time.now }


  private

  def set_up
    self.xid = SecureRandom.uuid
  end

end
