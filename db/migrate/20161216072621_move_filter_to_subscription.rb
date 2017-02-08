class MoveFilterToSubscription < ActiveRecord::Migration
  def change
    add_column :event_subscriptions, :filter, :string
    remove_column :filter_configs, :xid, :string
  end
end
