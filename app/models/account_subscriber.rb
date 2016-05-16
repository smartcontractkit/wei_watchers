class AccountSubscriber < ActiveRecord::Base

  belongs_to :account, inverse_of: :account_subscribers
  belongs_to :subscriber, inverse_of: :account_subscribers

  validates :account, presence: true
  validates :subscriber, presence: true, uniqueness: { scope: [:account] }

end
