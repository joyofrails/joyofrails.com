class CreateColorSchemes < ActiveRecord::Migration[7.1]
  def change
    create_table :color_schemes, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name, null: false, index: {unique: true}
      t.string :weight_50, null: false
      t.string :weight_100, null: false
      t.string :weight_200, null: false
      t.string :weight_300, null: false
      t.string :weight_400, null: false
      t.string :weight_500, null: false
      t.string :weight_600, null: false
      t.string :weight_700, null: false
      t.string :weight_800, null: false
      t.string :weight_900, null: false
      t.string :weight_950, null: false

      t.timestamps
    end
  end
end
