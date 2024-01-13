class CreateAdminUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :admin_users, :email, unique: true
  end
end
