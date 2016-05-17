FactoryGirl.define do
  factory :account do
    address { "0x#{ SecureRandom.hex 20 }" }
  end
end
