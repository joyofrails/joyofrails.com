class CreatePageEmbeddings < ActiveRecord::Migration[8.0]
  def up
    create_virtual_table :page_embeddings, :vec0, ["id text primary key", "embedding float[1536]"]
  end

  def down
    drop_table :page_embeddings
  end
end
