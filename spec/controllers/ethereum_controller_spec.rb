describe EthereumController, type: :controller do

  describe "#gas_price" do
    before { basic_auth_login }

    let(:gas_price) { rand 1_000_000_000_000 }

    it "returns the gas price via the Ethereum client" do
      expect_any_instance_of(EthereumClient).to receive(:gas_price)
        .and_return(gas_price)

      get :gas_price

      expect(json_response['wei']).to eq gas_price.to_s
      expect(json_response['acknowledged_at']).to be_present
    end
  end

end
