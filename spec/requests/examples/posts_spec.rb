require "rails_helper"

RSpec.describe "Examples::Posts", type: :request do
  describe "GET /index" do
    it "is successful" do
      get examples_posts_path
      expect(response).to have_http_status(:success)
    end
  end
end
