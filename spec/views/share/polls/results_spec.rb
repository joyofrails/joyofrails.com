require "rails_helper"

RSpec.describe Share::Polls::Results, type: :view do
  it "renders empty" do
    poll = FactoryBot.build(:poll)

    render Share::Polls::Results.new(poll)

    expect(rendered).to have_css("div")
  end

  it "renders a question and answer with no votes" do
    poll = FactoryBot.create(:poll)
    question = FactoryBot.create(:polls_question, poll: poll)
    FactoryBot.create(:polls_answer, question: question)

    render Share::Polls::Results.new(poll)

    expect(rendered).to have_css(".question")
    expect(rendered).to have_css(".answer")
    expect(rendered).to have_content("0%")
  end

  it "renders a question and answer with no votes" do
    poll = FactoryBot.create(:poll)
    question = FactoryBot.create(:polls_question, poll: poll)
    answer = FactoryBot.create(:polls_answer, question: question)
    FactoryBot.create(:polls_vote, answer: answer)

    render Share::Polls::Results.new(poll)

    expect(rendered).to have_css(".question")
    expect(rendered).to have_css(".answer")
    expect(rendered).to have_content("100.0%")
  end
end
