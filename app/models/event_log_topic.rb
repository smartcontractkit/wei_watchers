class EventLogTopic < ActiveRecord::Base

  belongs_to :topic, inverse_of: :event_log_topics
  belongs_to :event_log, inverse_of: :event_log_topics

  validates :topic, presence: true
  validates :event_log, presence: true

end
