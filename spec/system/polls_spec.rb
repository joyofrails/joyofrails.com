require "rails_helper"

RSpec.describe "Polls", type: :system do
  it "allows an anonymous user to vote" do
    poll = FactoryBot.create(:poll, author: FactoryBot.create(:user), title: "Color poll")
    question = FactoryBot.create(:polls_question, poll:, body: "What is your favorite color?")
    FactoryBot.create(:polls_answer, question:, body: "Red")
    FactoryBot.create(:polls_answer, question:, body: "Blue")
    FactoryBot.create(:polls_answer, question:, body: "Green")

    visit share_poll_path(poll)

    expect(page).to have_content("Color poll")
    expect(page).to have_content("What is your favorite color?")
    expect(page).to have_content("Red")
    expect(page).to have_content("Blue")
    expect(page).to have_content("Green")

    click_button "Red"

    expect(page).to have_content("Thank you for voting!")

    vote = poll.votes.last

    expect(vote.answer.body).to eq("Red")
  end
end
