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
end
