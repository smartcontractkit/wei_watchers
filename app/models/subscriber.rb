class Subscriber < ActiveRecord::Base

  validates :api_key, presence: true
  validates :notifier_id, presence: true
  validates :notifier_key, presence: true
  validates :notification_url, format: URI.regexp
  validates :xid, presence: true

end
