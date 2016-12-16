describe FilterTopic, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:topic).when(factory_create(:topic)) }
    it { is_expected.not_to have_valid(:topic).when(nil) }

    it { is_expected.to have_valid(:filter_config).when(factory_create(:filter_config)) }
    it { is_expected.not_to have_valid(:filter_config).when(nil) }
  end

end
