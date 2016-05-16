class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.text :notification_url
      t.string :xid
      t.string :api_key
      t.string :notifier_id
      t.string :notifier_key

      t.timestamps
    end
  end
end
