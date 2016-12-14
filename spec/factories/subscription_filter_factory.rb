FactoryGirl.define do

  factory :filter_subscription do
    end_at { 1.year.from_now }
    filter
    subscriber
  end

end
