class CreatePollsVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :polls_votes do |t|
      t.references :answer, null: false, foreign_key: {to_table: :polls_answers}
      t.references :user, null: true, foreign_key: true, type: :string
      t.string :device_uuid, index: true

      t.timestamps
    end
  end
end
