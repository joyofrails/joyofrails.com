require "rails_helper"

RSpec.describe "/votes", type: :request do
  describe "POST create" do
    it "creates a vote" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll: poll)
      answer = FactoryBot.create(:polls_answer, question: question)

      expect {
        post share_poll_votes_path(poll), params: {answer_id: answer.id}
      }.to change(Polls::Vote, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(share_poll_path(poll))
    end

    it "creates a vote on a second question" do
      poll = FactoryBot.create(:poll)
      question1 = FactoryBot.create(:polls_question, poll: poll)
      question2 = FactoryBot.create(:polls_question, poll: poll)
      answer_question1 = FactoryBot.create(:polls_answer, question: question1)
      answer_question2 = FactoryBot.create(:polls_answer, question: question2)

      post share_poll_votes_path(poll), params: {answer_id: answer_question1.id}

      expect {
        post share_poll_votes_path(poll), params: {answer_id: answer_question2.id}
      }.to change(Polls::Vote, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(share_poll_path(poll))
    end

    it "does not fail but also does not create a duplicate vote based on request cookie" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll: poll)
      answer1 = FactoryBot.create(:polls_answer, question: question)
      answer2 = FactoryBot.create(:polls_answer, question: question)

      post share_poll_votes_path(poll), params: {answer_id: answer1.id}

      expect {
        post share_poll_votes_path(poll), params: {answer_id: answer2.id}
      }.not_to change(Polls::Vote, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(share_poll_path(poll))
    end
  end
end
