class EventLogTopic < ActiveRecord::Base

  belongs_to :event_topic, inverse_of: :event_log_topics
  belongs_to :event_log, inverse_of: :event_log_topics

  validates :event_topic, presence: true
  validates :event_log, presence: true

end
