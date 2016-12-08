class Filter < ActiveRecord::Base

  belongs_to :account

  validates :from_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }
  validates :to_block, numericality: {
    allow_nil: true, greater_than_or_equal_to: 0, only_integer: true }

  def topics=(new_topics = [])
    self.topics_json = Array.wrap(new_topics).to_json
    topics
  end

  def topics
    if topics_json.present?
      JSON.parse(topics_json)
    else
      []
    end
  end

end
