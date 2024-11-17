require "rails_helper"

RSpec.describe Page::Similarity, type: :model do
  describe "#related_articles" do
    it "finds related articles" do
      article = FactoryBot.create(:page, :published, request_path: "/articles/web-push-notifications-from-rails")
      similar = FactoryBot.create(:page, :published, request_path: "/articles/add-your-rails-app-to-the-home-screen")

      embeddings_yaml = YAML.load_file(Rails.root.join("spec/fixtures/embeddings.yml"))

      [article, similar].each do |page|
        PageEmbedding.upsert_embedding!(page, embeddings_yaml[page.request_path])
      end

      expect(article.reload.related_articles).to include similar
    end

    it "returns empty when no embedding is calculated" do
      article = FactoryBot.create(:page, :published, request_path: "/articles/web-push-notifications-from-rails")

      expect(article.related_articles.to_a).to be_empty
    end
  end
end
