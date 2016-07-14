class CallController < ApiController

  skip_before_filter :check_basic_credentials, :authenticate_subscriber

  before_filter :check_data_and_to_params

  def show
    render json: {
      data: params[:data],
      int: int,
      base10: int.to_s,
      result: result,
      time: Time.now.to_i,
      to: params[:to],
      utf8: utf8,
    }
  end

  private

  def ethereum
    @ethereum ||= EthereumClient.new
  end

  def result
    @result ||= ethereum.call({
      data: params[:data],
      to: params[:to],
      gas_limit: params[:gas_limit],
      gas_price: params[:gas_price],
    }).result
  end

  def int
    begin
      result.gsub(/\A0x/,'').to_i(16)
    rescue
      nil
    end
  end

  def utf8
    begin
      ethereum.hex_to_utf8(result)
    rescue
      nil
    end
  end

  def check_data_and_to_params
    unless params[:data] && params[:to]
      render json: {
        errors: ["Must include a 'to' and 'data' param"]
      }
    end
  end

end
