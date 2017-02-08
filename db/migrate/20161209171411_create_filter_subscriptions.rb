class CreateFilterSubscriptions < ActiveRecord::Migration
  def change
    create_table :filter_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :filter_id
      t.datetime :end_at

      t.timestamps
    end
  end
end
