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

  def port_open?(ip, port, seconds=1)
    Timeout::timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
      false
  end

  def hex_to_bin(hex)
    [hex].pack('H*')
  end

  def bin_to_hex(bin)
    bin.unpack('H*')[0]
  end

end
