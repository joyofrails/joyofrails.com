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
FactoryBot.define do
  factory :polls_question, class: "Polls::Question" do
    body { "How cool is Joy of Rails?" }

    poll { build(:poll) }
  end
end
