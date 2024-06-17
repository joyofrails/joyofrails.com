class CreateEmailExchanges < ActiveRecord::Migration[7.1]
  def change
    create_table :email_exchanges do |t|
      t.string :email, null: false
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :status, null: false, default: 0 # pending

      t.timestamps
    end

    # Ensure that each user has only one pending unconfirmed email for a given email address
    add_index :email_exchanges, [:user_id, :email], unique: true, where: "status = 0"
  end
end
