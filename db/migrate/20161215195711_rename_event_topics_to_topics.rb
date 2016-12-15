class RenameEventTopicsToTopics < ActiveRecord::Migration
  def change
    rename_table :event_topics, :topics
    rename_column :event_log_topics, :event_topic_id, :topic_id
    rename_column :filter_topics, :event_topic_id, :topic_id
  end
end
