class Topic < ActiveRecord::Base

  has_many :event_log_topics, inverse_of: :topic
  has_many :event_logs, through: :event_log_topics
  has_many :filter_topics, inverse_of: :topic
  has_many :filters, through: :filter_topics

  validates :topic, format: /\A0x[0-9a-f]*\z/, uniqueness: true

end
