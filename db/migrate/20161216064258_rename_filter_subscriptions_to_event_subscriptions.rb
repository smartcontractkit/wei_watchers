class RenameFilterSubscriptionsToEventSubscriptions < ActiveRecord::Migration
  def change
    rename_table :filter_subscriptions, :event_subscriptions
  end
end
