class CreateNotificationEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_events do |t|
      t.string :type
      t.json :params
      t.integer :notifications_count, default: 0

      t.timestamps
    end
  end
end
