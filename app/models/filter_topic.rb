class FilterTopic < ActiveRecord::Base

  belongs_to :event_topic, inverse_of: :filter_topics
  belongs_to :filter, inverse_of: :filter_topics

  validates :event_topic, presence: true
  validates :filter, presence: true

end
