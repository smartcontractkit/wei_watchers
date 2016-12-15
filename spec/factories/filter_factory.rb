FactoryGirl.define do
  factory :filter do
    xid { new_filter_id }
  end

  factory :filter_with_subscriber, parent: :filter do
    filter_subscription
  end
end
