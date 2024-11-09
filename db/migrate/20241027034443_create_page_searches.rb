class CreatePageSearches < ActiveRecord::Migration[8.0]
  def up
    create_virtual_table :pages_search_index, :fts5, ["title", "body", "page_id"]
  end

  def down
    drop_virtual_table :pages_search_index
  end
end
