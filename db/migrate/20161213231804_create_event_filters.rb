class CreateEventFilters < ActiveRecord::Migration
  def change
    create_table :event_filters do |t|
      t.integer :event_log_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
