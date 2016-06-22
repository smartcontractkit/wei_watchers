class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
