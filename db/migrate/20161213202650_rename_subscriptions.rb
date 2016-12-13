class RenameSubscriptions < ActiveRecord::Migration
  def change
    rename_table :subscriptions, :balance_subscriptions
  end
end
