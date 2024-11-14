class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.string :slug, null: false, index: {unique: true}
      t.string :status, null: false, default: "pending", index: true
      t.integer :pages_count, null: false, default: 0, index: true
      t.timestamps
    end
  end
end
