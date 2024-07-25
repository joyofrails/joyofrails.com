require "rails_helper"

RSpec.describe "Examples::Posts", type: :request do
  describe "GET /index" do
    context "feature enabled" do
      before do
        user = login_user
        Flipper.enable(:example_posts, user)
      end

      it "is successful" do
        get examples_posts_path
        expect(response).to have_http_status(:success)
      end
    end

    context "user not authenticated" do
      before do
        Flipper.enable(:example_posts)
      end

      it "is not found" do
        get examples_posts_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "feature disabled" do
      before do
        login_user
        Flipper.disable(:example_posts)
      end

      it "is not found" do
        get examples_posts_path
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
