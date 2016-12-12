class EventTopic < ActiveRecord::Base

  validates :topic, format: /\A0x[0-9a-f]{64}\z/

end
