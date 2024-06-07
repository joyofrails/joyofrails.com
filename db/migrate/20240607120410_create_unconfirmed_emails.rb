class CreateUnconfirmedEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :unconfirmed_emails do |t|
      t.string :email, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 0 # pending

      t.timestamps
    end
  end
end
