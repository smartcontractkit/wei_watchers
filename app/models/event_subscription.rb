class EventSubscription < ActiveRecord::Base

  belongs_to :filter_config, inverse_of: :event_subscription
  belongs_to :subscriber, inverse_of: :event_subscriptions
  has_many :events, through: :filter_config

  validates :subscriber, presence: true
  validates :end_at, presence: true
  validates :filter_config, presence: true
  validates_associated :filter_config

  scope :current, -> { where "end_at >= ?", Time.now }

  def self.reset_current_filters
    current.pluck(:id).each do |id|
      FilterReseter.perform(id)
    end
  end

  def xid
    filter_config.xid
  end


end
