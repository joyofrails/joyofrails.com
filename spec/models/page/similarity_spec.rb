require "rails_helper"

RSpec.describe Page::Similarity, type: :model do
  describe "#related_pages" do
    it "finds related articles" do
      article = FactoryBot.create(:page, :published, request_path: "/articles/web-push-notifications-from-rails")
      similar = FactoryBot.create(:page, :published, request_path: "/articles/add-your-rails-app-to-the-home-screen")
      unindexed = FactoryBot.create(:page, :published, request_path: "/")

      embeddings_yaml = YAML.load_file(Rails.root.join("spec/fixtures/embeddings.yml"))

      [article, similar].each do |page|
        PageEmbedding.upsert_embedding!(page, embeddings_yaml[page.request_path])
      end

      article.reload

      expect(article.related_pages).to include similar
      expect(article.related_pages).not_to include article

      # works with additional scope
      expect(article.related_pages.published).to include similar
      expect(article.related_pages.published).not_to include unindexed, article
    end

    it "returns empty when no embedding is calculated" do
      article = FactoryBot.create(:page, :published, request_path: "/articles/web-push-notifications-from-rails")

      article.reload

      expect(article.related_pages).to be_empty
    end
  end
end
