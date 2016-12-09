class FilterSubscription < ActiveRecord::Base

  belongs_to :filter, inverse_of: :filter_subscription
  belongs_to :subscriber, inverse_of: :filter_subscriptions

  validates :subscriber, presence: true
  validates :end_at, presence: true
  validates :filter, presence: true
  validates_associated :filter

  def xid
    filter.xid
  end

end
