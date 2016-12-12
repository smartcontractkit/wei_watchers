FactoryGirl.define do

  factory :event_topic do
    topic { "0x#{ SecureRandom.hex 32 }" }
  end

end
