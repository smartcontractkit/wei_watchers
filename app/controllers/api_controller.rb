class ApiController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_filter :check_basic_credentials, :authenticate_subscriber


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
    render json: hash.merge(acknowledged_at: Time.now.to_i)
  end

  def failure_response(errors)
    render json: errors
  end

end
