describe Subscriber, type: :model do
  describe "validations" do
    it { is_expected.to have_valid(:notification_url).when('https://example.com/api/notifiy') }
    it { is_expected.not_to have_valid(:notification_url).when(nil, '', 'blah.com') }

    it { is_expected.to have_valid(:xid).when(SecureRandom.urlsafe_base64) }
    it { is_expected.not_to have_valid(:xid).when(nil, '') }

    it { is_expected.to have_valid(:api_key).when(SecureRandom.urlsafe_base64) }
    it { is_expected.not_to have_valid(:api_key).when(nil, '') }

    it { is_expected.to have_valid(:notifier_id).when(SecureRandom.urlsafe_base64) }
    it { is_expected.not_to have_valid(:notifier_id).when(nil, '') }

    it { is_expected.to have_valid(:notifier_key).when(SecureRandom.urlsafe_base64) }
    it { is_expected.not_to have_valid(:notifier_key).when(nil, '') }
  end
end
