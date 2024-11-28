# == Schema Information
#
# Table name: polls
#
#  id         :string           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :string           not null
#
# Indexes
#
#  index_polls_on_author_id  (author_id)
#  index_polls_on_title      (title)
#
# Foreign Keys
#
#  author_id  (author_id => users.id)
#
class Poll < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :questions, class_name: "Polls::Question", dependent: :destroy
  has_many :answers, through: :questions
  has_many :votes, through: :answers

  broadcasts_to ->(poll) { [poll.author, "polls"] }, inserts_by: :prepend

  scope :ordered, -> { order(id: :desc) }

  def record_vote(answer_id:, device_uuid:, user: nil)
    answers.find(answer_id).votes.create do |vote|
      vote.user = user if user
      vote.device_uuid = device_uuid
    end
  end
end
