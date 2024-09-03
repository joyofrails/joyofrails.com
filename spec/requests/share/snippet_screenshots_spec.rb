require "rails_helper"

RSpec.describe "/snippets/:id/screenshot", type: :request do
  describe "GET show" do
    it "is successful" do
      get share_snippet_screenshot_path(FactoryBot.create(:snippet))

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "is successful" do
      get new_share_snippet_screenshot_path(FactoryBot.create(:snippet))

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    let(:png_data_uri) { "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" }

    it "attaches screenshot and redirects to show" do
      post share_snippet_screenshot_path(FactoryBot.create(:snippet)), params: {screenshot: png_data_uri}

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(share_snippet_path(Snippet.last))
    end

    it "attaches screenshot and redirects to share" do
      post share_snippet_screenshot_path(FactoryBot.create(:snippet)), params: {intent: "share", screenshot: png_data_uri}

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_share_snippet_tweet_url(Snippet.last, auto: true))
    end
  end
end
