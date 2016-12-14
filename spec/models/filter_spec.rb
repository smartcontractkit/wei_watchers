describe Filter do

  describe "validations" do
    it { is_expected.to have_valid(:account).when(factory_create(:account), nil) }

    it { is_expected.to have_valid(:from_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:from_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:to_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:to_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:xid).when("0x#{SecureRandom.hex(16)}") }
    it { is_expected.not_to have_valid(:xid).when('', "0x", "0x#{SecureRandom.hex(17)}") }
  end

  describe "on create" do
    let(:account) { factory_create :account }
    let(:filter_id) { new_filter_id }
    let(:filter) { Filter.new account: account }

    it "creates a filter on the blockchain and saves its ID" do
      expect_any_instance_of(EthereumClient).to receive(:create_filter)
        .with({
          account: account.address,
          fromBlock: nil,
          toBlock: nil,
          topics: [],
        })
        .and_return(filter_id)

      expect {
        filter.save
      }.to change {
        filter.xid
      }.from(nil).to(filter_id)
    end
  end

end
