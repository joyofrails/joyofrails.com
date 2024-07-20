class AddProcessedAtToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :processed_at, :datetime
  end
end
