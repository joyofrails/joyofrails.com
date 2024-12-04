require "rails_helper"

RSpec.describe "Polls", type: :system do
  it "allows an anonymous user to vote" do
    poll = FactoryBot.create(:poll, author: FactoryBot.create(:user), title: "Color poll")
    question = FactoryBot.create(:polls_question, poll:, body: "What is your favorite color?")
    answer1 = FactoryBot.create(:polls_answer, question:, body: "Red")
    answer2 = FactoryBot.create(:polls_answer, question:, body: "Blue")
    FactoryBot.create(:polls_answer, question:, body: "Green")

    visit share_poll_path(poll)

    expect(page).to have_content("Color poll")
    expect(page).to have_content("What is your favorite color?")
    expect(page).to have_content("Red")
    expect(page).to have_content("Blue")
    expect(page).to have_content("Green")

    click_button "Red"

    expect(page).to have_content("Thank you for voting!")
    within("#polls_question_#{question.id}_polls_answer_#{answer1.id}") do
      expect(page).to have_content("100.0%")
    end
    expect(page).to have_content("1 vote")

    vote = poll.votes.last
    expect(vote.answer.body).to eq("Red")

    Capybara.using_session("Another guest session") do
      visit share_poll_path(poll)

      click_button "Blue"

      expect(page).to have_content("Thank you for voting!")
      within("#polls_question_#{question.id}_polls_answer_#{answer1.id}") do
        expect(page).to have_content("50.0")
      end
      within("#polls_question_#{question.id}_polls_answer_#{answer2.id}") do
        expect(page).to have_content("50.0%")
      end
      expect(page).to have_content("2 votes")
    end

    # We could theoretically test that the original user sees the refreshed
    # results but I could only get this to work in system tests when the
    # broadcast was emitted in process while "refresh later" via background job,
    # as I would prefer it work, doesn’t seem to work with test adapters for
    # solid cable / solid queue.
  end
end
