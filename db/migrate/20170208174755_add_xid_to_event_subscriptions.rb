class AddXidToEventSubscriptions < ActiveRecord::Migration

  def change
    add_column :event_subscriptions, :xid, :string
  end

end
