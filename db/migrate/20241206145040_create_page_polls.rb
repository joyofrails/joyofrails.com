class CreatePagePolls < ActiveRecord::Migration[8.0]
  def change
    create_table :page_polls do |t|
      t.references :page, null: false, foreign_key: true, type: :string
      t.references :poll, null: false, foreign_key: true, type: :string

      t.timestamps
    end

    add_index :page_polls, [:page_id, :poll_id], unique: true
  end
end
