class EventTopic < ActiveRecord::Base

  has_many :log_event_topics, inverse_of: :event_topic
  has_many :log_events, through: :log_event_topics

  validates :topic, format: /\A0x[0-9a-f]{64}\z/

end
