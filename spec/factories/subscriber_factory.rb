FactoryGirl.define do
  factory :subscriber do
    notification_url { "https://example-#{SecureRandom.hex}.smartcontract.com/api/notifications" }
  end
end
