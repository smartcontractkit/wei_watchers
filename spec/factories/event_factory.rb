FactoryGirl.define do

  factory :event do
    association :account
    block_hash { "0x#{ SecureRandom.hex 32 }" }
    block_number { rand(1_000_000) }
    log_index { rand(1_000_000) }
    transaction_hash { "0x#{ SecureRandom.hex 32 }" }
    transaction_index { rand(1_000_000) }
  end

end
