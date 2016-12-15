describe EventTopic, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:topic).when(factory_create(:topic)) }
    it { is_expected.not_to have_valid(:topic).when(nil) }

    it { is_expected.to have_valid(:event).when(factory_create(:event)) }
    it { is_expected.not_to have_valid(:event).when(nil) }
  end

end
