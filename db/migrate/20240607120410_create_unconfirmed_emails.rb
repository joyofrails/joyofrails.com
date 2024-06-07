class CreateUnconfirmedEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :unconfirmed_emails do |t|
      t.string :email, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 0 # pending

      t.timestamps
    end

    # Ensure that each user has only one pending unconfirmed email for a given email address
    add_index :unconfirmed_emails, [:user_id, :email], unique: true, where: "status = 0"
  end
end
