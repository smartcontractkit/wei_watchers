FactoryGirl.define do

  factory :event_filter do
    event
    association :filter, factory: :filter_with_subscriber
  end

end
