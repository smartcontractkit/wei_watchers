describe FilterConfig do

  describe "validations" do
    it { is_expected.to have_valid(:account).when(factory_create(:account), nil) }

    it { is_expected.to have_valid(:from_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:from_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:to_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:to_block).when(-1, 0.1) }
  end

end
