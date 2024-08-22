class CreateSnippets < ActiveRecord::Migration[7.1]
  def change
    create_table :snippets, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.text :source, null: false
      t.string :filename
      t.string :language
      t.text :url

      t.timestamps
    end
  end
end
