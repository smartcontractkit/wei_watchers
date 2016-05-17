class AddEndDateToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :end_at, :datetime
  end
end
