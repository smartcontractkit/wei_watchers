class CreateLogEvents < ActiveRecord::Migration
  def change
    create_table :log_events do |t|
      t.integer :account_id
      t.string :block_hash
      t.integer :block_number
      t.string :data
      t.integer :log_index
      t.string :transaction_hash
      t.integer :transaction_index

      t.timestamps
    end
  end
end
