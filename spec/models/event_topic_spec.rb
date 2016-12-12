describe EventTopic, type: :model do

  describe "validations" do
    let(:old_topic) { factory_create(:event_topic).topic }

    it { is_expected.to have_valid(:topic).when("0x#{SecureRandom.hex 32}") }
    it { is_expected.not_to have_valid(:topic).when(nil, '', '0x' "0x#{SecureRandom.hex 33}", old_topic) }
  end

end
