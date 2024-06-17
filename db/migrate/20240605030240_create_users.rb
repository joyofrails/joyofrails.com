class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
