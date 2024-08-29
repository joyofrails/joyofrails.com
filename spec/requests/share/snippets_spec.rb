require "rails_helper"

RSpec.describe "/snippets", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      Flipper.enable(:snippets, login_as_user)

      FactoryBot.create(:snippet)
      get share_snippets_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      Flipper.enable(:snippets, login_as_user)

      snippet = FactoryBot.create(:snippet)
      get share_snippet_url(snippet)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      Flipper.enable(:snippets, login_as_user)
      get new_share_snippet_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      Flipper.enable(:snippets, login_as_user)
      snippet = FactoryBot.create(:snippet)
      get edit_share_snippet_url(snippet)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "creates a new Snippet" do
        expect {
          post share_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby"}}
        }.to change(Snippet, :count).by(1)
      end

      it "redirects back to the edit page" do
        post share_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby"}}
        expect(response).to redirect_to(edit_share_snippet_url(Snippet.last))
      end
    end

    context "with invalid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "does not create a new Snippet" do
        expect {
          post share_snippets_url, params: {snippet: {}}
        }.to change(Snippet, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post share_snippets_url, params: {snippet: {}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "updates the requested snippet" do
        snippet = FactoryBot.create(:snippet)
        patch share_snippet_url(snippet), params: {snippet: {source: "puts \"Goodbye!\""}}
        snippet.reload
        expect(snippet.source).to eq("puts \"Goodbye!\"")
      end

      it "redirects back to the edit page" do
        snippet = FactoryBot.create(:snippet)
        patch share_snippet_url(snippet), params: {snippet: {source: "puts \"Goodbye!\""}}
        snippet.reload
        expect(response).to redirect_to(edit_share_snippet_url(snippet))
      end
    end

    context "with invalid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        snippet = FactoryBot.create(:snippet)
        patch share_snippet_url(snippet), params: {snippet: {language: "does_not_exist"}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested snippet" do
      Flipper.enable(:snippets, login_as_user)
      snippet = FactoryBot.create(:snippet)
      expect {
        delete share_snippet_url(snippet)
      }.to change(Snippet, :count).by(-1)
    end

    it "redirects to the snippets list" do
      Flipper.enable(:snippets, login_as_user)
      snippet = FactoryBot.create(:snippet)
      delete share_snippet_url(snippet)
      expect(response).to redirect_to(share_snippets_url)
    end
  end
end
