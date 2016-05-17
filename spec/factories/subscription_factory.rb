FactoryGirl.define do
  factory :subscription do
    account
    end_at { 1.day.from_now }
    subscriber
  end
end
