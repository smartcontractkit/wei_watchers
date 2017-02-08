class RenameEventLogsToEvents < ActiveRecord::Migration
  def change
    rename_table :event_logs, :events
    rename_table :event_log_topics, :event_topics
    rename_column :event_filters, :event_log_id, :event_id
    rename_column :event_topics, :event_log_id, :event_id
  end
end
