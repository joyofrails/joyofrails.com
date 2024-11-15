class AddIndexedAtToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :indexed_at, :datetime, null: true

    add_index :pages, :indexed_at
  end
end
