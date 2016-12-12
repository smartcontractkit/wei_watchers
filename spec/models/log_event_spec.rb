describe LogEvent, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:account).when(factory_create(:account)) }
    it { is_expected.not_to have_valid(:account).when(nil) }

    it { is_expected.to have_valid(:block_hash).when("0x#{ SecureRandom.hex 32 }") }
    it { is_expected.not_to have_valid(:block_hash).when(nil, '', "0x", "0x#{ SecureRandom.hex 33 }") }

    it { is_expected.to have_valid(:block_number).when(0, 1) }
    it { is_expected.not_to have_valid(:block_number).when(-1, nil) }

    it { is_expected.to have_valid(:data).when(nil, '', "0x", "0x#{SecureRandom.hex 256}") }

    it { is_expected.to have_valid(:log_index).when(0, 1) }
    it { is_expected.not_to have_valid(:log_index).when(-1, nil) }

    it { is_expected.to have_valid(:transaction_hash).when("0x#{ SecureRandom.hex 32 }") }
    it { is_expected.not_to have_valid(:transaction_hash).when(nil, '', "0x", "0x#{ SecureRandom.hex 33 }") }

    it { is_expected.to have_valid(:transaction_index).when(0, 1) }
    it { is_expected.not_to have_valid(:transaction_index).when(-1, nil) }
  end

end
