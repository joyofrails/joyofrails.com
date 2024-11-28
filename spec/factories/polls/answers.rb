# == Schema Information
#
# Table name: polls_answers
#
#  id          :integer          not null, primary key
#  body        :string           not null
#  position    :integer          default(0), not null
#  votes_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer          not null
#
# Indexes
#
#  index_polls_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  question_id  (question_id => polls_questions.id)
#
FactoryBot.define do
  factory :polls_answer, class: "Polls::Answer" do
    question { nil }
  end
end
