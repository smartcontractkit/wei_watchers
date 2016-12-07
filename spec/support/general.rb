module SpecHelpers

  def hashie(hash)
    Hashie::Mash.new hash
  end

  def factory_create(factory_name, options = {})
    FactoryGirl.create(factory_name, options)
  end

  def factory_build(factory_name, options = {})
    FactoryGirl.build(factory_name, options)
  end

  def basic_auth_login(subscriber = factory_create(:subscriber))
    user = subscriber.api_id
    password = subscriber.api_key
    auth = ActionController::HttpAuthentication::Basic.encode_credentials user, password
    request.env['HTTP_AUTHORIZATION'] = auth
  end

  def json_response
    JSON.parse(response.body)
  end

end
