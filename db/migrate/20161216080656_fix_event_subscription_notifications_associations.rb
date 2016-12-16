class FixEventSubscriptionNotificationsAssociations < ActiveRecord::Migration

  def change
    rename_column :event_subscription_notifications, :filter_config_id, :event_subscription_id
  end

end
