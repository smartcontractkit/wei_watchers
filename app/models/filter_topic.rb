class FilterTopic < ActiveRecord::Base

  belongs_to :topic, inverse_of: :filter_topics
  belongs_to :filter, inverse_of: :filter_topics

  validates :topic, presence: true
  validates :filter, presence: true

end
