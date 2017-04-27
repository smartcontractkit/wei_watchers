describe FilterConfig do

  describe "validations" do
    it { is_expected.to have_valid(:account).when(factory_create(:account), nil) }

    it { is_expected.to have_valid(:from_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:from_block).when(-1, 0.1) }

    it { is_expected.to have_valid(:to_block).when(nil, 0, 1, 324656235467344) }
    it { is_expected.not_to have_valid(:to_block).when(-1, 0.1) }
  end

  describe "#params" do
    let(:filter) { factory_create :filter_config }
    let(:params) { filter.params }

    it "returns all of the present filter details" do
      expect(params[:address]).to eq(filter.address)
      expect(params[:topics]).to eq(filter.topic_ids)

      expect(params.keys).not_to include(:fromBlock)
      expect(params.keys).not_to include(:toBlock)
    end

    context "when block height params are present" do
      let(:from_block) { 1234 }
      let(:to_block) { 9876 }
      let(:filter) { factory_create :filter_config, from_block: from_block, to_block: to_block }

      it "formats them as hex" do
        expect(params[:fromBlock]).to eq("0x" + ethereum.format_int_to_hex(from_block))
        expect(params[:toBlock]).to eq("0x" + ethereum.format_int_to_hex(to_block))
      end
    end
  end

end
