class RenameAccountSubscribersSubscriptions < ActiveRecord::Migration
  def change
    rename_table :account_subscribers, :subscriptions
  end
end
