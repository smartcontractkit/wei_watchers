class RenameFiltersToFilterConfigs < ActiveRecord::Migration
  def change
    rename_table :filters, :filter_configs
    rename_column :event_subscription_notifications, :filter_id, :filter_config_id
    rename_column :event_subscriptions, :filter_id, :filter_config_id
    rename_column :filter_topics, :filter_id, :filter_config_id
  end
end
