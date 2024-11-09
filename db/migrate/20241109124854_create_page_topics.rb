class CreatePageTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :page_topics do |t|
      t.references :page, null: false, foreign_key: true, type: :string
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end

    add_index :page_topics, [:page_id, :topic_id], unique: true
  end
end
