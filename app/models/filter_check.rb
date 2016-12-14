class FilterCheck

  include HasEthereumClient

  def self.schedule_checks
    FilterSubscription.current.pluck(:id).uniq.each do |subscription_id|
      delay.perform subscription_id
    end
  end

  def self.perform(id)
    subscription = FilterSubscription.find(id)
    new(subscription).perform
  end

  def initialize(subscription)
    @subscription = subscription
    @filter = subscription.filter
  end

  def perform
    new_logs.each do |log|
      EventLogger.perform(log)
    end
  end


  private

  attr_reader :filter, :subscription

  def new_logs
    @new_logs ||= ethereum.get_filter_changes(filter.xid)
  end

end
