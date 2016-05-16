class CreateAccountSubscribers < ActiveRecord::Migration
  def change
    create_table :account_subscribers do |t|
      t.integer :account_id
      t.integer :subscriber_id

      t.timestamps
    end
  end
end
