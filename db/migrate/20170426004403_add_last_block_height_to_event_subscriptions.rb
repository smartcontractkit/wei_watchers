class AddLastBlockHeightToEventSubscriptions < ActiveRecord::Migration

  def change
    add_column :event_subscriptions, :last_block_height, :integer, default: 0
  end

end
