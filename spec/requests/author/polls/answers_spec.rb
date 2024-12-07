require "rails_helper"

RSpec.describe "/answers", type: :request do
  describe "GET /new" do
    it "renders a successful response" do
      user = login_as_user
      poll = FactoryBot.create(:poll, author: user)
      question = FactoryBot.create(:polls_question, poll:)
      Flipper.enable(:polls, user)

      get new_author_poll_question_answer_url(poll, question)

      expect(response).to be_successful
    end

    it "is not found when not authenticated" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      Flipper.enable(:polls)

      get new_author_poll_question_answer_url(poll, question)
      expect(response).to be_not_found
    end

    it "is not found when not authorized" do
      user = login_as_user
      poll = FactoryBot.create(:poll, author: user)
      question = FactoryBot.create(:polls_question, poll:)
      Flipper.disable(:polls)

      get new_author_poll_question_answer_url(poll, question)

      expect(response).to be_not_found
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = login_as_user
      poll = FactoryBot.create(:poll, author: user)
      question = FactoryBot.create(:polls_question, poll:)
      answer = FactoryBot.create(:polls_answer, question:)
      Flipper.enable(:polls, user)

      get edit_author_poll_answer_url(poll, answer)

      expect(response).to be_successful
    end

    it "is not found when not authenticated" do
      poll = FactoryBot.create(:poll)
      question = FactoryBot.create(:polls_question, poll:)
      answer = FactoryBot.create(:polls_answer, question:)
      Flipper.enable(:polls)

      get edit_author_poll_answer_url(poll, answer)

      expect(response).to be_not_found
    end

    it "is not found when not authorized" do
      user = login_as_user
      poll = FactoryBot.create(:poll, author: user)
      question = FactoryBot.create(:polls_question, poll:)
      answer = FactoryBot.create(:polls_answer, question:)
      Flipper.disable(:polls)

      get edit_author_poll_answer_url(poll, answer)

      expect(response).to be_not_found
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Polls::Question" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        Flipper.enable(:polls, user)

        expect {
          post author_poll_question_answers_url(poll, question), params: {answer: {body: "Bob"}}
        }.to change(Polls::Answer, :count).by(1)

        question = Polls::Answer.last
        expect(question.body).to eq("Bob")
      end

      it "associates question with the given poll" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        Flipper.enable(:polls, user)

        post author_poll_question_answers_url(poll, question), params: {answer: {body: "Bob"}}

        expect(Polls::Question.last.poll).to eq(poll)
      end

      it "redirects to the poll show page" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        Flipper.enable(:polls, user)

        post author_poll_question_answers_url(poll, question), params: {answer: {body: "Bob"}}

        expect(response).to redirect_to(author_poll_url(poll))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Polls::Question" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        Flipper.enable(:polls, user)

        expect {
          post author_poll_questions_url(poll), params: {question: {body: ""}}
        }.to change(Polls::Question, :count).by(0)
      end

      it "renders bad request" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        Flipper.enable(:polls, user)

        post author_poll_questions_url(poll), params: {question: {body: ""}}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when not authenticated" do
      it "is not found" do
        poll = FactoryBot.create(:poll)
        Flipper.enable(:polls)

        post author_poll_questions_url(poll), params: {question: {body: "Bob"}}

        expect(response).to be_not_found
      end
    end

    context "when not authorized" do
      it "is not found" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        Flipper.disable(:polls, user)

        post author_poll_questions_url(poll), params: {question: {body: "Bob"}}

        expect(response).to be_not_found
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested question" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.enable(:polls, user)

        patch author_poll_answer_url(poll, answer), params: {answer: {body: "puts \"Goodbye!\""}}

        answer.reload
        expect(answer.body).to eq("puts \"Goodbye!\"")
      end

      it "redirects to the poll show page" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.enable(:polls, user)

        patch author_poll_answer_url(poll, answer), params: {answer: {body: "puts \"Goodbye!\""}}

        answer.reload
        expect(response).to redirect_to(author_poll_url(poll))
      end
    end

    context "with invalid parameters" do
      it "is unprocessable" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.enable(:polls, user)

        patch author_poll_answer_url(poll, answer), params: {answer: {body: ""}}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when not authenticated" do
      it "is not found" do
        poll = FactoryBot.create(:poll)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.enable(:polls)

        patch author_poll_answer_url(poll, answer), params: {answer: {body: "javascript"}}

        expect(response).to be_not_found
        expect(answer.reload.body).to_not eq("javascript")
      end
    end

    context "when not authorized" do
      it "is not found" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.disable(:polls, user)

        patch author_poll_answer_url(poll, answer), params: {answer: {body: "javascript"}}

        expect(response).to be_not_found
        expect(answer.reload.body).to_not eq("javascript")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested question" do
      user = login_as_user
      poll = FactoryBot.create(:poll, author: user)
      question = FactoryBot.create(:polls_question, poll:)
      answer = FactoryBot.create(:polls_answer, question:)
      Flipper.enable(:polls, user)

      expect {
        delete author_poll_answer_url(poll, answer)
      }.to change(Polls::Answer, :count).by(-1)

      expect { answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(author_poll_url(poll))
    end

    context "when not authenticated" do
      it "is not found" do
        poll = FactoryBot.create(:poll)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.enable(:polls)

        delete author_poll_answer_url(poll, answer)

        expect(response).to be_not_found
        expect(answer.reload).to eq(answer)
      end
    end

    context "when not authorized" do
      it "is not found" do
        user = login_as_user
        poll = FactoryBot.create(:poll, author: user)
        question = FactoryBot.create(:polls_question, poll:)
        answer = FactoryBot.create(:polls_answer, question:)
        Flipper.disable(:polls, user)

        delete author_poll_answer_url(poll, answer)

        expect(response).to be_not_found
        expect(answer.reload).to eq(answer)
      end
    end
  end
end
