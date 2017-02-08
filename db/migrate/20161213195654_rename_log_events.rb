class RenameLogEvents < ActiveRecord::Migration
  def up
    rename_table :log_events, :event_logs
    rename_column :log_event_topics, :log_event_id, :event_log_id
    rename_table :log_event_topics, :event_log_topics
  end

  def down
    rename_table :event_log_topics, :log_event_topics
    rename_column :log_event_topics, :event_log_id, :log_event_id
    rename_table :event_logs, :log_events
  end
end
