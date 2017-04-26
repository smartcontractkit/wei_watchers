class EventSubscription < ActiveRecord::Base

  include HasEthereumClient

  belongs_to :filter_config, inverse_of: :event_subscription
  belongs_to :subscriber, inverse_of: :event_subscriptions
  has_many :events, through: :event_subscription_notifications
  has_many :event_subscription_notifications, inverse_of: :event_subscription

  validates :subscriber, presence: true
  validates :end_at, presence: true
  validates :filter_config, presence: true
  validates_associated :filter_config

  before_validation :set_up, on: :create
  after_create :check_missed_events

  scope :current, -> { where "end_at >= ?", Time.now }

  def self.reset_current_filters
    current.pluck(:id).each do |id|
      SubscriptionReset.perform(id)
    end
  end

  def filter_params
    filter_config.params.merge({
      fromBlock: formatted_block_height,
    }).compact
  end


  private

  def set_up
    self.xid = SecureRandom.uuid
    return unless filter_config.present?
  end

  def check_missed_events
    SubscriptionCheck.delay.perform(id)
  end

  def formatted_block_height
    "0x#{ethereum.format_int_to_hex last_block_height}"
  end

end
