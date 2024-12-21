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
require "rails_helper"

RSpec.describe Poll, type: :model do
  describe ".generate_for" do
    it "creates a poll with questions and answers" do
      FactoryBot.create(:user, :primary_author)
      page = FactoryBot.create(:page)
      poll = Poll.generate_for(
        page,
        "Color poll",
        "What's your favorite color?" => ["Red", "Green", "Blue"]
      )
      expect(poll).to be_persisted
      expect(poll.title).to eq("Color poll")
      expect(poll.questions.count).to eq(1)

      question = poll.questions.first

      expect(question.body).to eq("What's your favorite color?")
      expect(question.answers.count).to eq(3)
      expect(question.answers.map(&:body)).to eq(["Red", "Green", "Blue"])
    end

    it "is idempotent by title" do
      FactoryBot.create(:user, :primary_author)
      page = FactoryBot.create(:page)

      Poll.generate_for(page, "Color poll",
        "What's your favorite color?" => ["Red", "Green", "Blue"])

      expect {
        Poll.generate_for(page, "Color poll", {})
      }.not_to change(Poll, :count)
    end
  end

  describe "#completed?" do
    it "returns true if all questions have been voted on" do
      poll = FactoryBot.create(:poll)
      q1 = FactoryBot.create(:polls_question, poll: poll)
      q2 = FactoryBot.create(:polls_question, poll: poll)
      q3 = FactoryBot.create(:polls_question, poll: poll)
      a1_q1 = FactoryBot.create(:polls_answer, question: q1)
      _a2_q1 = FactoryBot.create(:polls_answer, question: q1)
      _a1_q2 = FactoryBot.create(:polls_answer, question: q2)
      a2_q2 = FactoryBot.create(:polls_answer, question: q2)
      _a1_q3 = FactoryBot.create(:polls_answer, question: q3)
      a2_q3 = FactoryBot.create(:polls_answer, question: q3)

      uuid = SecureRandom.uuid_v7
      FactoryBot.create(:polls_vote, answer: a1_q1, device_uuid: uuid)
      FactoryBot.create(:polls_vote, answer: a2_q2, device_uuid: uuid)

      expect(poll.completed?(uuid)).to eq(false)

      FactoryBot.create(:polls_vote, answer: a2_q3, device_uuid: uuid)

      expect(poll.completed?(uuid)).to eq(true)
    end
  end
end
