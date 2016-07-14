describe CallController, type: :controller do
  describe "#show" do
    let(:data) { '9fa6a6e3' }
    let(:to) { '0x5a14460da6f51330a82d90c7cbbf8d5afdfb0291' }
    let(:result) { '0x0000000000000000000000000000000000000000000000000000000000000064' }

    before do
      Timecop.freeze
    end

    it "returns the result of a call to Ethereum" do
      expect_any_instance_of(EthereumClient).to receive(:call)
        .with(data: data, to: to, gas_limit: nil, gas_price: nil)
        .and_return(double result: result)

      get :show, data: data, to: to

      response_json = JSON.parse response.body
      expect(response_json).to eq({
        "data" => data,
        "int" => 100,
        "base10" => "100",
        "result" => result,
        "time" => Time.now.to_i,
        "to" => to,
        "utf8" => 'd',
      })
    end
  end
end
