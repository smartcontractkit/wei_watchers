FactoryGirl.define do
  factory :balance_subscription do
    account
    end_at { 1.day.from_now }
    subscriber
  end
end
