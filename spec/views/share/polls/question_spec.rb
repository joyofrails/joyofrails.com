require "rails_helper"

RSpec.describe Share::Polls::Question, type: :view do
  context "when not voted on" do
    it "renders with no answers" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)

      render described_class.new(poll:, question:, voted: false)

      expect(rendered).to have_css("p")
    end

    it "renders ballot button for an answer" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      FactoryBot.create(:polls_answer, question:)

      render described_class.new(poll:, question:, voted: false)

      expect(rendered).to have_css("button", count: 1)
    end

    it "renders ballot button for each answer" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      FactoryBot.create(:polls_answer, question:)
      FactoryBot.create(:polls_answer, question:)

      render described_class.new(poll:, question:, voted: false)

      expect(rendered).to have_css("button", count: 2)
    end
  end

  context "when voted on" do
    it "renders results for question and answer with no votes" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      FactoryBot.create(:polls_answer, question:)

      render described_class.new(poll:, question:, voted: true)

      expect(rendered).to have_css(".question")
      expect(rendered).to have_css(".answer")
      expect(rendered).to have_content("0%")
      expect(rendered).not_to match(/width:/)
    end

    it "renders a question and answer with votes" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      answer = FactoryBot.create(:polls_answer, question:)
      FactoryBot.create(:polls_vote, answer:)

      render described_class.new(poll:, question:, voted: true)

      expect(rendered).to have_css(".question")
      expect(rendered).to have_css(".answer")
      expect(rendered).to have_content("100.0%")
      expect(rendered).to match(/width: 100.0%/)
    end
  end
end
