class AddRevisionTimestampsToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :pages, :revised_at, :datetime, null: true # For manually tracking content revisions
    add_column :pages, :upserted_at, :datetime, null: true # For automatically tracking upserts
  end
end
