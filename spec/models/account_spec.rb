describe Account, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:address).when("0x#{SecureRandom.hex 20}") }
    it { is_expected.not_to have_valid(:address).when(nil, '', "0x", SecureRandom.hex(20), "0x#{SecureRandom.hex 19}") }

    it { is_expected.to have_valid(:balance).when(0, 1, 32452345234562352462346246234624626535626432623462462) }
    it { is_expected.not_to have_valid(:balance).when(nil, -1, 0.1) }
  end
end
