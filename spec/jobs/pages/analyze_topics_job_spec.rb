require "rails_helper"

RSpec.describe Pages::AnalyzeTopicsJob, type: :job do
  describe "#perform" do
    it "analyzes the topics of a page" do
      page = Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

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
end
