require "rails_helper"

RSpec.describe "/snippets", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      FactoryBot.create(:snippet, author: user)
      get author_snippets_url
      expect(response).to be_successful
    end

    it "renders a successful response without filename" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      FactoryBot.create(:snippet, author: user, filename: nil)
      get author_snippets_url
      expect(response).to be_successful
    end

    it "renders a successful response without description" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      FactoryBot.create(:snippet, author: user, description: nil)
      get author_snippets_url
      expect(response).to be_successful
    end

    it "does not render the New Snippet button when not allowed" do
      user = login_as_user
      Flipper.disable(:snippets, user)
      get author_snippets_url

      expect(response).to be_not_found
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user)
      get author_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "renders a successful response without filename" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user, filename: nil)
      get author_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "renders a successful response without description" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user, description: nil)
      get author_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "redirects when not allowed" do
      snippet = FactoryBot.create(:snippet)
      get author_snippet_url(snippet)

      expect(response).to be_not_found
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      Flipper.enable(:snippets, login_as_user)
      get new_author_snippet_url
      expect(response).to be_successful
    end

    it "redirects when not authenticated" do
      get new_author_snippet_url
      expect(response).to be_not_found
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user)
      get edit_author_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "renders a 404" do
      login_as_user
      Flipper.enable(:snippets)
      snippet = FactoryBot.create(:snippet)
      get edit_author_snippet_url(snippet)
      expect(response).to be_not_found
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "creates a new Snippet" do
        expect {
          post author_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby", filename: "hello.rb", description: "A simple greeting"}}
        }.to change(Snippet, :count).by(1)

        snippet = Snippet.last
        expect(snippet.source).to eq("puts \"Hello!\"")
        expect(snippet.language).to eq("ruby")
        expect(snippet.filename).to eq("hello.rb")
        expect(snippet.description).to eq("A simple greeting")
      end

      it "associates snippet with the current user" do
        user = login_as_user
        Flipper.enable(:snippets, user)

        post author_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby"}}

        expect(Snippet.last.author).to eq(user)
      end

      it "redirects back to the edit page" do
        post author_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby"}}
        expect(response).to redirect_to(edit_author_snippet_url(Snippet.last))
      end

      it "redirects to the show page" do
        post author_snippets_url, params: {snippet: {source: "puts \"Hello!\"", language: "ruby"}, commit: "Save & Close"}
        expect(response).to redirect_to(author_snippet_url(Snippet.last))
      end
    end

    context "with invalid parameters" do
      before do
        Flipper.enable(:snippets, login_as_user)
      end

      it "does not create a new Snippet" do
        expect {
          post author_snippets_url, params: {snippet: {}}
        }.to change(Snippet, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post author_snippets_url, params: {snippet: {}}
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when not authenticated" do
      it "renders a 404" do
        post author_snippets_url, params: {snippet: {}}
        expect(response).to be_not_found
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        Flipper.disable(:snippets, login_as_user)

        post author_snippets_url, params: {snippet: {}}
        expect(response).to be_not_found
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested snippet" do
        user = login_as_user
        Flipper.enable(:snippets, user)
        snippet = FactoryBot.create(:snippet, author: user)
        patch author_snippet_url(snippet), params: {snippet: {source: "puts \"Goodbye!\""}}
        snippet.reload
        expect(snippet.source).to eq("puts \"Goodbye!\"")
      end

      it "redirects back to the edit page" do
        user = login_as_user
        Flipper.enable(:snippets, user)
        snippet = FactoryBot.create(:snippet, author: user)
        patch author_snippet_url(snippet), params: {snippet: {source: "puts \"Goodbye!\""}}
        snippet.reload
        expect(response).to redirect_to(edit_author_snippet_url(snippet))
      end

      it "redirects to the show page" do
        user = login_as_user
        Flipper.enable(:snippets, user)
        snippet = FactoryBot.create(:snippet, author: user)
        patch author_snippet_url(snippet), params: {snippet: {source: "puts \"Goodbye!\""}, commit: "Save & Close"}
        snippet.reload
        expect(response).to redirect_to(author_snippet_url(snippet))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        user = login_as_user
        Flipper.enable(:snippets, user)
        snippet = FactoryBot.create(:snippet, author: user)
        patch author_snippet_url(snippet), params: {snippet: {language: "does_not_exist"}}
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when not authenticated" do
      it "renders a 404" do
        snippet = FactoryBot.create(:snippet)
        patch author_snippet_url(snippet), params: {snippet: {language: "javascript"}}
        expect(response).to be_not_found
        expect(snippet.reload.language).to_not eq("javascript")
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        snippet = FactoryBot.create(:snippet, author: login_as_user)
        patch author_snippet_url(snippet), params: {snippet: {language: "javascript"}}
        expect(response).to be_not_found
        expect(snippet.reload.language).to_not eq("javascript")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested snippet" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user)

      expect {
        delete author_snippet_url(snippet)
      }.to change(Snippet, :count).by(-1)
    end

    it "redirects to the snippets list" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user)

      expect {
        delete author_snippet_url(snippet)
      }.to change(Snippet, :count).by(-1)

      expect { snippet.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(author_snippets_url)
    end

    context "when not authenticated" do
      it "renders a 404" do
        snippet = FactoryBot.create(:snippet)
        delete author_snippet_url(snippet)
        expect(response).to be_not_found
        expect(snippet.reload).to eq(snippet)
      end
    end

    context "when not authorized" do
      it "renders a 404" do
        snippet = FactoryBot.create(:snippet, author: login_as_user)
        delete author_snippet_url(snippet)
        expect(response).to be_not_found
        expect(snippet.reload).to eq(snippet)
      end
    end
  end
end
