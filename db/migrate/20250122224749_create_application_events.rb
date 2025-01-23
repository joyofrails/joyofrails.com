class CreateApplicationEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :application_events, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :type, null: false
      t.text :metadata
      t.text :data, null: false
      t.timestamps
    end
  end
end
