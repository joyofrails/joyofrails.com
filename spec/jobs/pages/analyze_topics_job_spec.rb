require "rails_helper"

RSpec.describe Pages::AnalyzeTopicsJob, type: :job do
  describe "#perform" do
    it "analyzes the topics of a page" do
      page = FactoryBot.create(:page, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

      response = {
        id: "chatcmpl-ARm3zTYmf11ldAIJx9JywO8XjmKof",
        object: "chat.completion",
        model: "gpt-4o-mini",
        choices: [
          {
            index: 0,
            message: {
              role: "assistant",
              content: "{\"topics\":[\"Ruby on Rails\",\"Hotwire\",\"CSS\",\"Tailwind\"]}"
            }
          }
        ]
      }

      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .to_return(json_response(response))

      Pages::AnalyzeTopicsJob.perform_now(page)

      expect(page.reload.topics.pluck(:name)).to include("Ruby on Rails")
    end
  end

  describe Pages::AnalyzeTopicsJob::Batch do
    it "doesn’t blow up" do
      allow(Page).to receive(:render_html).and_return(Faker::HTML.random)

      topics = FactoryBot.create_list(:topic, 2)

      page_1, page_2, page_3 = Page.upsert_collection_from_sitepress!(limit: 3).each do |page|
        page.touch(:published_at)
      end

      # articles without topics
      page_1.update!(topics: [])
      page_2.update!(topics: [])

      # articles with topics
      page_3.update!(topics: topics)

      # not articles
      FactoryBot.create_list(:page, 3)

      expect(Pages::AnalyzeTopicsJob).to receive(:perform_later).exactly(2).times

      described_class.perform_now
    end
  end
end
