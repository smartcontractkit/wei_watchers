FactoryGirl.define do
  factory :filter do
    xid { "0x#{ SecureRandom.hex 32 }" }
  end
end
