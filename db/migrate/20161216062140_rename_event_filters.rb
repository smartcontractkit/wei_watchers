class RenameEventFilters < ActiveRecord::Migration
  def change
    rename_table :event_filters, :event_subscription_notifications
  end
end
