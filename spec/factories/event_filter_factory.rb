FactoryGirl.define do

  factory :event_filter do
    event_log
    association :filter, factory: :filter_with_subscriber
  end

end
