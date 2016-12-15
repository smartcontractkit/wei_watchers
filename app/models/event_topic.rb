class EventTopic < ActiveRecord::Base

  belongs_to :topic, inverse_of: :event_topics
  belongs_to :event, inverse_of: :event_topics

  validates :topic, presence: true
  validates :event, presence: true

end
