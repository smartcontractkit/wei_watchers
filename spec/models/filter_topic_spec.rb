describe FilterTopic, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event_topic).when(factory_create(:event_topic)) }
    it { is_expected.not_to have_valid(:event_topic).when(nil) }

    it { is_expected.to have_valid(:filter).when(factory_create(:filter)) }
    it { is_expected.not_to have_valid(:filter).when(nil) }
  end

end
