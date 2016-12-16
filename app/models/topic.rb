class Topic < ActiveRecord::Base

  has_many :event_topics, inverse_of: :topic
  has_many :events, through: :event_topics
  has_many :filter_topics, inverse_of: :topic
  has_many :filter_configs, through: :filter_topics

  validates :topic, format: /\A0x[0-9a-f]*\z/, uniqueness: true

end
