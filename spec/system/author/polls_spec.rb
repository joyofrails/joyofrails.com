require "rails_helper"

RSpec.describe "Polls", type: :system do
  it "allows an authenticated user to create a poll" do
    author = FactoryBot.create(:user)
    Flipper.enable(:polls, author)
    poll = FactoryBot.create(:poll, author:, title: "Color poll")
    question = FactoryBot.create(:polls_question, poll:, body: "What is your favorite color?")
    FactoryBot.create(:polls_answer, question:, body: "Red")
    FactoryBot.create(:polls_answer, question:, body: "Blue")
    FactoryBot.create(:polls_answer, question:, body: "Green")

    login_user(author)

    visit author_poll_path(poll)

    expect(page).to have_content("Color poll")
    expect(page).to have_content("What is your favorite color?")
    expect(page).to have_content("Red")
    expect(page).to have_content("Blue")
    expect(page).to have_content("Green")

    click_link "+ New question"
    fill_in "Body", with: "What is your favorite animal?"
    click_button "Save question"
    expect(page).to have_content("What is your favorite animal?")

    last_question = Polls::Question.last
    expect(last_question.body).to eq("What is your favorite animal?")
    expect(last_question.poll).to eq(poll)

    within "#polls_question_#{last_question.id}" do
      click_link "+ New answer"
      fill_in "Body", with: "Dog"
      click_button "Save answer"

      expect(page).to have_content("Dog")
    end

    last_answer = Polls::Answer.last

    expect(last_answer.body).to eq("Dog")
    expect(last_answer.question).to eq(last_question)
  end
end
