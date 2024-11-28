class CreatePolls < ActiveRecord::Migration[8.0]
  def change
    create_table :polls, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :author, null: false, foreign_key: {to_table: :users}, type: :string
      t.string :title, null: false, index: true

      t.timestamps
    end
  end
end
