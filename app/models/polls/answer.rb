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
class Polls::Answer < ApplicationRecord
  belongs_to :question, touch: true, inverse_of: :answers
  has_many :votes, class_name: "Polls::Vote", dependent: :destroy

  scope :ordered, -> { order(position: :asc, id: :asc) }

  validates :body, presence: true
end
