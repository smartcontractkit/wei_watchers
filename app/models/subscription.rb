class Subscription < ActiveRecord::Base

  belongs_to :account, inverse_of: :subscriptions
  belongs_to :subscriber, inverse_of: :subscriptions

  validates :account, presence: true
  validates :end_at, presence: true
  validates :subscriber, presence: true

  scope :current, -> { where "end_at > ?", Time.now }

end
