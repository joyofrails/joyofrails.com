class CreateExamplesPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :examples_posts do |t|
      t.string :title, null: false
      t.references :postable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
