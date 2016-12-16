FactoryGirl.define do

  factory :event_subscription_notification do
    event
    association :filter_config, factory: :filter_config_with_subscriber
  end

end
