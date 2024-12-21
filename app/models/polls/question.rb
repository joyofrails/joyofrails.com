# == Schema Information
#
# Table name: polls_questions
#
#  id         :integer          not null, primary key
#  body       :string           not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :string           not null
#
# Indexes
#
#  index_polls_questions_on_poll_id  (poll_id)
#
# Foreign Keys
#
#  poll_id  (poll_id => polls.id)
#
class Polls::Question < ApplicationRecord
  belongs_to :poll, touch: true
  has_many :answers, class_name: "Polls::Answer", dependent: :destroy, inverse_of: :question
  has_many :votes, through: :answers

  validates :body, presence: true

  scope :ordered, -> { order(position: :asc, id: :asc) }

  def votes_count
    answers.sum(&:votes_count)
  end
end
