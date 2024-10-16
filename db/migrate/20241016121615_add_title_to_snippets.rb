class AddTitleToSnippets < ActiveRecord::Migration[8.0]
  def change
    add_column :snippets, :title, :string
  end
end
