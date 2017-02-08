class MoveFilterEventsToJoinTable < ActiveRecord::Migration
  def change
    remove_column :filters, :topics_json, :text
    create_table :filter_topics do |t|
      t.integer :event_topic_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
