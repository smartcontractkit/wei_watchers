class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include HasEthereumClient


  def status
    block_height = ethereum.current_block_height
    if block_height
      render json: {
        block: block_height.to_s,
        time: Time.now.to_i.to_s,
      }
    else
      render json: {
        errors: ['Temporarily unavailable.'],
        time: Time.now.to_i
      }, status: :service_unavailable
    end
  end

end
