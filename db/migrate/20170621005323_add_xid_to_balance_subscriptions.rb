class AddXidToBalanceSubscriptions < ActiveRecord::Migration

  def up
    add_column :balance_subscriptions, :xid, :string

    BalanceSubscription.pluck(:id).each do |id|
      subscription = BalanceSubscription.find(id)
      subscription.update_attributes xid: SecureRandom.uuid
    end
  end

  def down
    remove_column :balance_subscriptions, :xid, :string
  end

end
