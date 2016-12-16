FactoryGirl.define do

  factory :event_subscription do
    end_at { 1.year.from_now }
    filter
    subscriber
  end

end
