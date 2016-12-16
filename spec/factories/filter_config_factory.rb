FactoryGirl.define do
  factory :filter_config do
  end

  factory :filter_config_with_subscriber, parent: :filter_config do
    event_subscription
  end
end
