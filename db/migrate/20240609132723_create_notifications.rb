class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :type
      t.references :notification_event, null: false, foreign_key: true
      t.references :recipient, polymorphic: true, null: false, type: :string
      t.datetime :read_at
      t.datetime :seen_at

      t.timestamps
    end
  end
end
