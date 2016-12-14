class EventFilter < ActiveRecord::Base

  belongs_to :event_log, inverse_of: :event_filters
  belongs_to :filter, inverse_of: :event_filters

  validates :event_log, presence: true
  validates :filter, presence: true

  after_create :log_event_with_subscriber


  private

  def log_event_with_subscriber
    filter.subscriber.event_log event_log_id
  end

end
