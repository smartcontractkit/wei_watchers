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

  def basic_auth_login(subscriber = factory_create(:subscriber), hash = request.env)
    user = subscriber.api_id
    password = subscriber.api_key
    auth = ActionController::HttpAuthentication::Basic.encode_credentials user, password
    hash['HTTP_AUTHORIZATION'] = auth
    hash
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

  def http_response(options = {})
    double(:fake_http_response, {body: {}.to_json, success?: true}.merge(options))
  end

  def unstub_ethereum_calls
    allow(EthereumClient).to receive(:post)
      .and_call_original

    allow_any_instance_of(EthereumClient).to receive(:gas_price)
      .and_call_original

    allow_any_instance_of(EthereumClient).to receive(:get_transaction_count)
      .and_call_original

    allow_any_instance_of(EthereumClient).to receive(:create_filter)
      .and_call_original
  end

  def uint_to_hex(int)
    ethereum.format_uint_to_hex(int)
  end

  def complete_all_current_background_jobs
    Delayed::Job.all.each do |dj|
      dj.tap(&:invoke_job).destroy
    end
  end

  def check_event_subscriptions
    SubscriptionCheck.schedule_checks
    complete_all_current_background_jobs # generates job to create event
    complete_all_current_background_jobs # runs job create event
  end

  def reset_event_subscriptions
    EventSubscription.reset_current_filters
    complete_all_current_background_jobs # resets all current filters
  end

end
