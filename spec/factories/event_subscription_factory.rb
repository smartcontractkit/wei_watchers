FactoryGirl.define do

  factory :event_subscription do
    end_at { 1.year.from_now }
    filter_config
    subscriber
  end

end
