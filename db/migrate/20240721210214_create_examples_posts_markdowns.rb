class CreateExamplesPostsMarkdowns < ActiveRecord::Migration[7.1]
  def change
    create_table :examples_posts_markdowns do |t|
      t.text :body, null: false

      t.timestamps
    end
  end
end
