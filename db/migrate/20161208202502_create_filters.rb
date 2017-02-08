class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :xid
      t.integer :account_id
      t.integer :from_block
      t.integer :to_block
      t.text :topics_json

      t.timestamps
    end
  end
end
