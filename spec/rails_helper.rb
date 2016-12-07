# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  include SpecHelpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.add_setting :geth_pid

  config.before(:suite) do |example|
    port = 7434
    geth = "geth --dev --mine --fakepow --etherbase 0x4f5f1e8029640b873a43c427e9a4f03cf56ec6d8 --rpc --rpccorsdomain '*' --rpcport #{port} --ipcpath './tmp/geth.ipc' --datadir './tmp' --lightkdf --verbosity 0"
    closed = true
    attempts = 0

    geth_pid = fork { exec geth }
    RSpec.configuration.geth_pid = geth_pid
    Process.detach(geth_pid)

    while (closed && attempts < 60) do
      if port_open?('localhost', port, 30)
        closed = false
      else
        attempts += 1
        sleep 0.5
      end
    end

    raise "geth didn't start after 30 seconds" if closed
  end

  config.after(:suite) do |example|
    Process.kill "TERM", RSpec.configuration.geth_pid
  end
end
