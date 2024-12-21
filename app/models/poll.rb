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
  has_many :page_polls, dependent: :destroy
  has_many :pages, through: :page_polls

  validates :title, presence: true

  scope :ordered, -> { order(id: :desc) }

  def self.generate_for(
    page,
    title,
    questions = {}
  )
    poll = page.polls.find_by(title: title) and return poll
    author = Page.primary_author or return nil
    poll = author.polls.create!(title: title)
    poll.pages << page
    poll.questions = questions.map do |question_body, answers|
      question = poll.questions.build(body: question_body)
      question.answers = answers.map do |answer_body|
        question.answers.build(body: answer_body)
      end
      question
    end
    poll.save
    poll
  end

  def completed?(device_uuid)
    questions.all? do |question|
      question.voted?(device_uuid: device_uuid)
    end
  end
end
