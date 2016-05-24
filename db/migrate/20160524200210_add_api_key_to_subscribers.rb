class AddApiKeyToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :api_id, :string
  end
end
