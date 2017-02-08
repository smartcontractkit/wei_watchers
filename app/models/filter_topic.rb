class FilterTopic < ActiveRecord::Base

  belongs_to :topic, inverse_of: :filter_topics
  belongs_to :filter_config, inverse_of: :filter_topics

  validates :topic, presence: true
  validates :filter_config, presence: true

end
