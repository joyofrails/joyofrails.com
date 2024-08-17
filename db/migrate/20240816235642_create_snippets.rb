class CreateSnippets < ActiveRecord::Migration[7.1]
  def change
    create_table :snippets, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title
      t.text :source, null: false
      t.text :url

      t.timestamps
    end
  end
end
