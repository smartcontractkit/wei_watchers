class EventSubscription < ActiveRecord::Base

  belongs_to :filter_config, inverse_of: :event_subscription
  belongs_to :subscriber, inverse_of: :event_subscriptions
  has_many :events, through: :event_subscription_notifications
  has_many :event_subscription_notifications, inverse_of: :event_subscription

  validates :subscriber, presence: true
  validates :end_at, presence: true
  validates :filter, format: /\A0x[0-9a-f]{32}\z/
  validates :filter_config, presence: true
  validates_associated :filter_config

  before_validation :create_filter, on: :create

  scope :current, -> { where "end_at >= ?", Time.now }

  def self.reset_current_filters
    current.pluck(:id).each do |id|
      FilterReseter.perform(id)
    end
  end

  def new_on_chain_filter(options = {})
    ethereum.create_filter filter_params.merge(options)
  end


  private

  def create_filter
    return unless filter_config.present?
    self.filter ||= new_on_chain_filter
  end

  def filter_params
    filter_config.params
  end

end
