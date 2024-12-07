require "rails_helper"

RSpec.describe "Site: articles" do
  let(:first_article) { SitepressArticle.published.first }

  # Filter out index.html.erb from article pages before selecting first draft
  let(:first_draft) { SitepressArticle.draft.lazy.filter { |article| article.page.request_path != "/articles" }.first }

  describe "GET /" do
    it "lists recent published articles" do
      get "/"

      expect(response).to have_http_status(:ok)
    end

    it "supports preview flag" do
      get "/", params: {preview: true}

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /articles" do
    it "lists published articles" do
      Page.upsert_collection_from_sitepress!
      get "/articles"

      expect(response).to have_http_status(:ok)

      expect(response.body).to include(first_article.title)
      expect(response.body).not_to include(first_draft.title) if first_draft
    end
  end

  describe "GET /drafts" do
    it "lists draft articles" do
      Page.upsert_collection_from_sitepress!
      get "/drafts"

      expect(response).to have_http_status(:ok)

      expect(response.body).to include(first_draft.title) if first_draft
      expect(response.body).not_to include(first_article.title)
    end
  end
end
