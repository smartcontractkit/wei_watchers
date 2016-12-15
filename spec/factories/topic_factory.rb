FactoryGirl.define do

  factory :topic do
    topic { "0x#{ SecureRandom.hex 32 }" }
  end

end
