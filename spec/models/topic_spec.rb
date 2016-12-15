describe Topic, type: :model do

  describe "validations" do
    let(:old_topic) { factory_create(:topic).topic }

    it { is_expected.to have_valid(:topic).when('0x', '0xf', "0x#{SecureRandom.hex 32}", "0x#{SecureRandom.hex 33}") }
    it { is_expected.not_to have_valid(:topic).when(nil, '', old_topic) }
  end

end
