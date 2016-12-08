describe Filter do
  describe "validations" do
    it { is_expected.to have_valid(:account).when(factory_create(:account), nil) }

    it { is_expected.to have_valid(:from_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:from_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:to_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:to_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:topics).when(nil, '' '0x10', [], ['0x10'], [['0x01', '0x02'], ['0x03', '0x04']]) }

    it { is_expected.to have_valid(:xid).when(nil, 'blank') }
  end
end
