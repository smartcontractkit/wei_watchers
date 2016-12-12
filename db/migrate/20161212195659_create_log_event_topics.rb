class CreateLogEventTopics < ActiveRecord::Migration
  def change
    create_table :log_event_topics do |t|
      t.integer :event_topic_id
      t.integer :log_event_id

      t.timestamps
    end
  end
end
