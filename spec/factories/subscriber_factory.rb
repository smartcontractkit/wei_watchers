FactoryGirl.define do
  factory :subscriber do
    api_id { SecureRandom.hex }
    api_key { SecureRandom.hex }
    notifier_id { SecureRandom.hex }
    notifier_key { SecureRandom.hex }
    notification_url { "https://example-#{SecureRandom.hex}.smartcontract.com/api/notifications" }
    xid { SecureRandom.hex }
  end
end
