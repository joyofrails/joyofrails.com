class CreateNewsletters < ActiveRecord::Migration[7.1]
  def change
    create_table :newsletters, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :sent_at

      t.timestamps
    end
  end
end
