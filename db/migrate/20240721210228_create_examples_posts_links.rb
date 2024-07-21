class CreateExamplesPostsLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :examples_posts_links do |t|
      t.string :url, null: false

      t.timestamps
    end
  end
end
