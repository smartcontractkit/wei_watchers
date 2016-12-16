FactoryGirl.define do

  factory :event_subscription_notification do
    event
    association :filter, factory: :filter_with_subscriber
  end

end
