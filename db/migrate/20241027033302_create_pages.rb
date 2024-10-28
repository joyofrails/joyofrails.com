class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :request_path, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
