module HttpClient

  def self.included(base)
    base.include HTTParty
  end

  def self.random_id
    SecureRandom.random_number(1_000_000)
  end


  private

  def get(path, options = {})
    self.class.get(path.to_s, {
      basic_auth: http_client_auth_params,
      query: options,
      headers: headers
    }.compact)
  end

  def post(path, options = {})
    self.class.post(path.to_s, {
      basic_auth: http_client_auth_params,
      body: options,
      headers: headers
    }.compact)
  end

  def delete(path, options = {})
    self.class.delete(path.to_s, {
      basic_auth: http_client_auth_params,
      body: options,
      headers: headers
    }.compact)
  end

  def json_get(path, options = {})
    JSON.parse get(path, options).body
  end

  def json_post(path, options = {})
    JSON.parse post(path, options).body
  end

  def hashie_get(path, options = {})
    hashie json_get(path, options)
  end

  def hashie_post(path, options = {})
    hashie json_post(path, options)
  end

  def hashie(hash)
    Hashie::Mash.new hash
  end

  def headers
    nil
  end

  def http_client_auth_params
    nil
  end

end
