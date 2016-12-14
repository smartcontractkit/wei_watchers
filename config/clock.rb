require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    system "rails runner '#{job}'"
  end

  every(1.minute, 'FilterCheck.schedule_checks')
  every(1.minute, 'BalanceCheck.schedule_checks')
end
