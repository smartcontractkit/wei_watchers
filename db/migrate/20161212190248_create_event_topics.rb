class CreateEventTopics < ActiveRecord::Migration
  def change
    create_table :event_topics do |t|
      t.string :topic

      t.timestamps
    end
  end
end
