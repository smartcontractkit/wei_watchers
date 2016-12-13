class EventTopic < ActiveRecord::Base

  has_many :event_log_topics, inverse_of: :event_topic
  has_many :event_logs, through: :event_log_topics

  validates :topic, format: /\A0x[0-9a-f]*\z/, uniqueness: true

end
