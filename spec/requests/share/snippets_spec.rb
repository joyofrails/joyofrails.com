require "rails_helper"

RSpec.describe "/snippets", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      FactoryBot.create(:snippet)
      get share_snippets_url
      expect(response).to be_successful
    end

    it "renders a successful response without filename" do
      FactoryBot.create(:snippet, filename: nil)
      get share_snippets_url
      expect(response).to be_successful
    end

    it "renders a successful response without description" do
      FactoryBot.create(:snippet, description: nil)
      get share_snippets_url
      expect(response).to be_successful
    end

    it "does not render the New Snippet button when not allowed" do
      get share_snippets_url

      expect(page).to_not have_content("New Snippet")
    end

    it "renders the New Snippet button when allowed" do
      Flipper.enable(:snippets, login_as_user)
      get share_snippets_url

      expect(page).to have_content("New Snippet")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      snippet = FactoryBot.create(:snippet)
      get share_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "renders a successful response without filename" do
      snippet = FactoryBot.create(:snippet, filename: nil)
      get share_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "renders a successful response without description" do
      snippet = FactoryBot.create(:snippet, description: nil)
      get share_snippet_url(snippet)
      expect(response).to be_successful
    end

    it "does not render the Edit Snippet button when not allowed" do
      Flipper.enable(:snippets, login_as_user)
      snippet = FactoryBot.create(:snippet)
      get share_snippet_url(snippet)

      expect(page).to_not have_content("Edit this snippet")
    end

    it "renders the Edit Snippet button when allowed" do
      user = login_as_user
      Flipper.enable(:snippets, user)
      snippet = FactoryBot.create(:snippet, author: user)
      get share_snippet_url(snippet)

      expect(page).to have_content("Edit this snippet")
    end
  end
end
