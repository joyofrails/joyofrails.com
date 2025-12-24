require "rails_helper"

RSpec.describe "/polls", type: :request do
  describe "GET /index" do
    let(:user) { login_as_user }

    before do
      Flipper.enable(:polls, user)
    end

    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:polls, user)
      FactoryBot.create(:poll, author: user)
      get author_polls_url
      expect(response).to be_successful
    end

    it "does not render the New Poll button when not allowed" do
      user = login_as_user
      Flipper.disable(:polls, user)
      get author_polls_url

      expect(response).to be_not_found
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:polls, user)
      poll = FactoryBot.create(:poll, author: user)
      get author_poll_url(poll)
      expect(response).to be_successful
    end

    it "redirects when not allowed" do
      poll = FactoryBot.create(:poll, author: FactoryBot.create(:user))
      get author_poll_url(poll)

      expect(response).to be_not_found
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      Flipper.enable(:polls, login_as_user)
      get new_author_poll_url
      expect(response).to be_successful
    end

    it "redirects when not authenticated" do
      get new_author_poll_url
      expect(response).to be_not_found
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:polls, user)
      poll = FactoryBot.create(:poll, author: user)
      get edit_author_poll_url(poll)
      expect(response).to be_successful
    end

    it "renders a 404" do
      login_as_user
      Flipper.enable(:polls)
      poll = FactoryBot.create(:poll, author: FactoryBot.create(:user))
      get edit_author_poll_url(poll)
      expect(response).to be_not_found
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        Flipper.enable(:polls, login_as_user)
      end

      it "creates a new Poll" do
        expect {
          post author_polls_url, params: {poll: {title: "SQLite on Rails"}}
        }.to change(Poll, :count).by(1)

        poll = Poll.last
        expect(poll.title).to eq("SQLite on Rails")
      end

      it "associates poll with the current user" do
        user = login_as_user
        Flipper.enable(:polls, user)

        post author_polls_url, params: {poll: {title: "SQLite on Rails"}}

        expect(Poll.last.author).to eq(user)
      end

      it "redirects to the show page" do
        post author_polls_url, params: {poll: {title: "SQLite on Rails"}}
        expect(response).to redirect_to(author_poll_url(Poll.last))
      end
    end

    context "with invalid parameters" do
      before do
        Flipper.enable(:polls, login_as_user)
      end

      it "does not create a new Poll" do
        expect {
          post author_polls_url, params: {poll: {}}
        }.to change(Poll, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post author_polls_url, params: {poll: {title: ""}}

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when not authenticated" do
      it "renders a 404" do
        post author_polls_url, params: {poll: {}}
        expect(response).to be_not_found
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        Flipper.disable(:polls, login_as_user)

        post author_polls_url, params: {poll: {}}
        expect(response).to be_not_found
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested poll" do
        user = login_as_user
        Flipper.enable(:polls, user)
        poll = FactoryBot.create(:poll, author: user)
        patch author_poll_url(poll), params: {poll: {title: "SQLite on Rails"}}
        poll.reload
        expect(poll.title).to eq("SQLite on Rails")
      end

      it "redirects to the show page" do
        user = login_as_user
        Flipper.enable(:polls, user)
        poll = FactoryBot.create(:poll, author: user)
        patch author_poll_url(poll), params: {poll: {title: "SQLite on Rails"}}
        poll.reload
        expect(response).to redirect_to(author_poll_url(poll))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        user = login_as_user
        Flipper.enable(:polls, user)
        poll = FactoryBot.create(:poll, author: user)
        patch author_poll_url(poll), params: {poll: {title: ""}}
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when not authenticated" do
      it "renders a 404" do
        poll = FactoryBot.create(:poll, author: FactoryBot.create(:user))
        patch author_poll_url(poll), params: {poll: {title: "SQLite on Rails"}}
        expect(response).to be_not_found
        expect(poll.reload.title).to_not eq("SQLite on Rails")
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        poll = FactoryBot.create(:poll, author: login_as_user)
        patch author_poll_url(poll), params: {poll: {title: "SQLite on Rails"}}
        expect(response).to be_not_found
        expect(poll.reload.title).to_not eq("SQLite on Rails")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested poll" do
      user = login_as_user
      Flipper.enable(:polls, user)
      poll = FactoryBot.create(:poll, author: user)

      expect {
        delete author_poll_url(poll)
      }.to change(Poll, :count).by(-1)
    end

    it "redirects to the polls list" do
      user = login_as_user
      Flipper.enable(:polls, user)
      poll = FactoryBot.create(:poll, author: user)

      expect {
        delete author_poll_url(poll)
      }.to change(Poll, :count).by(-1)

      expect { poll.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(author_polls_url)
    end

    context "when not authenticated" do
      it "renders a 404" do
        poll = FactoryBot.create(:poll, author: FactoryBot.create(:user))
        delete author_poll_url(poll)
        expect(response).to be_not_found
        expect(poll.reload).to eq(poll)
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        poll = FactoryBot.create(:poll, author: login_as_user)
        delete author_poll_url(poll)
        expect(response).to be_not_found
        expect(poll.reload).to eq(poll)
      end
    end
  end
end
