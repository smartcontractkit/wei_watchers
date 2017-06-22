class ApiController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_filter :check_basic_credentials, :authenticate_subscriber

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


  private

  attr_reader :subscriber

  def render_authentication_message
    render json: {errors: ["Please log in to WeiWatchers to continue."]}
  end

  def check_basic_credentials
    unless ActionController::HttpAuthentication::Basic.has_basic_credentials? request
      render_authentication_message
    end
  end

  def authenticate_subscriber
    id, key = ActionController::HttpAuthentication::Basic::user_name_and_password request

    unless @subscriber = Subscriber.find_by(api_id: id, api_key: key)
      render_authentication_message
    end
  end

  def success_response(hash)
    render status: :ok, json: hash.merge(acknowledged_at: Time.now.to_i)
  end

  def failure_response(errors)
    render status: :bad_request, json: {errors: Array.wrap(errors)}
  end

end
