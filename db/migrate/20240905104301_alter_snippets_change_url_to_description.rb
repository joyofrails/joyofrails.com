class AlterSnippetsChangeUrlToDescription < ActiveRecord::Migration[7.2]
  def up
    rename_column :snippets, :url, :description
  end

  def down
    rename_column :snippets, :description, :url
  end
end
