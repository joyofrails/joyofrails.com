class IndexApplicationEventsCreatedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :application_events, :created_at
  end
end
