require "rails_helper"

RSpec.describe "Topics", type: :request do
  describe "GET /index" do
    it "returns http success" do
      article = Page.find_or_create_by!(request_path: "/articles/introducing-joy-of-rails")

      topic_1 = FactoryBot.create(:topic, :approved)
      topic_2 = FactoryBot.create(:topic, :approved)

      article.topics = [topic_1, topic_2]

      get topics_path

      expect(response).to have_http_status(:success)

      expect(page).to have_content(topic_1.name)
      expect(page).to have_content(topic_2.name)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      article = Page.find_or_create_by!(request_path: "/articles/introducing-joy-of-rails")
      topic = FactoryBot.create(:topic, :approved)
      article.topics << topic

      get topic_path(topic)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(topic.name)
      expect(response.body).to include("Introducing Joy of Rails")
    end
  end
end
