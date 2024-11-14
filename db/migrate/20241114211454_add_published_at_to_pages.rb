class AddPublishedAtToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :published_at, :datetime, null: true

    add_index :pages, :published_at
  end
end
