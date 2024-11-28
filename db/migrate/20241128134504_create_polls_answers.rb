class CreatePollsAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :polls_answers do |t|
      t.string :body, null: false
      t.references :question, null: false, foreign_key: {to_table: :polls_questions}
      t.integer :position, null: false, default: 0
      t.integer :votes_count, null: false, default: 0

      t.timestamps
    end
  end
end
