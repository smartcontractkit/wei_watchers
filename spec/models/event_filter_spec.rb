describe EventFilter, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event_log).when(factory_create(:event_log)) }
    it { is_expected.not_to have_valid(:event_log).when(nil) }

    it { is_expected.to have_valid(:filter).when(factory_create(:filter)) }
    it { is_expected.not_to have_valid(:filter).when(nil) }
  end

end
