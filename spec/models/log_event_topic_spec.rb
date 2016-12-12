describe LogEventTopic, type: :model do

  describe "validations" do
    it { is_expected.to have_valid(:event_topic).when(factory_create(:event_topic)) }
    it { is_expected.not_to have_valid(:event_topic).when(nil) }

    it { is_expected.to have_valid(:log_event).when(factory_create(:log_event)) }
    it { is_expected.not_to have_valid(:log_event).when(nil) }
  end

end
