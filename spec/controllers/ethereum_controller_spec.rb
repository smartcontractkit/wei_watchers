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

  describe "#send_raw_transaction" do
    before { basic_auth_login }

    let(:tx_hex) { SecureRandom.hex }

    before do
      expect_any_instance_of(EthereumClient).to receive(:send_raw_transaction)
        .and_return(ethereum_response)
    end

    context "when broadcasting the response returns a transaction ID" do
      let(:ethereum_response) { double txid: SecureRandom.hex, to_hash: {a: 1} }

      it "responds with an acknowledgement" do
        post :send_raw_transaction, hex: tx_hex

        expect(json_response['acknowledged_at']).to be_present
        expect(json_response['errors']).to be_nil
      end
    end

    context "when broadcasting the response returns a transaction ID" do
      let(:ethereum_response) { double error: {"code"=>-32000, "message"=>"rlp: expected input list for types.txdata"}, txid: nil }

      it "responds with an acknowledgement" do
        post :send_raw_transaction, hex: tx_hex

        expect(json_response['acknowledged_at']).to be_nil
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe "#get_transaction_count" do
    before { basic_auth_login }

    let(:account) { SecureRandom.hex }
    let(:tx_count) { rand 1_000_000_000_000 }

    it "returns the gas price via the Ethereum client" do
      expect_any_instance_of(EthereumClient).to receive(:get_transaction_count)
        .with(account)
        .and_return(tx_count)

      get :get_transaction_count, account: account

      expect(json_response['count']).to eq tx_count.to_s
      expect(json_response['acknowledged_at']).to be_present
    end
  end

  describe "#get_transaction" do
    before { basic_auth_login }

    let(:txid) { SecureRandom.hex }
    let(:ethereum_response) { { foo: 'b4r' } }

    it "returns the gas price via the Ethereum client" do
      expect_any_instance_of(EthereumClient).to receive(:get_transaction)
        .with(txid)
        .and_return(ethereum_response)

      get :get_transaction, txid: txid

      expect(json_response['foo']).to eq 'b4r'
      expect(json_response['acknowledged_at']).to be_present
    end
  end
end
