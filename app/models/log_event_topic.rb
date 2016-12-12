class LogEventTopic < ActiveRecord::Base

  belongs_to :event_topic, inverse_of: :log_event_topics
  belongs_to :log_event, inverse_of: :log_event_topics

  validates :event_topic, presence: true
  validates :log_event, presence: true

end
