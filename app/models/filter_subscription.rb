class FilterSubscription < ActiveRecord::Base

  belongs_to :filter
  belongs_to :subscriber

  validates :subscriber, presence: true
  validates :end_at, presence: true
  validates :filter, presence: true

end
