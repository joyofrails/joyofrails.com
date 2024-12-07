class CreatePollsQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :polls_questions do |t|
      t.string :body, null: false
      t.references :poll, null: false, foreign_key: true, type: :string
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
