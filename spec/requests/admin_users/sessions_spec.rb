require "rails_helper"

RSpec.describe "AdminUsers::Sessions", type: :request do
  describe "GET new" do
    it "returns http success" do
      get new_admin_users_session_path
      expect(response).to have_http_status(:success)
    end

    it "redirects if already signed in" do
      login_admin_user
      get new_admin_users_session_path
      expect(response).to have_http_status(:found)
    end
  end

  describe "POST create" do
    it "returns http success" do
      FactoryBot.create(:admin_user, email: "joy@joyofrails.com", password: "password")
      post admin_users_sessions_path, params: {admin_user: {email: "joy@joyofrails.com", password: "password"}}
      expect(response).to have_http_status(:found)
    end

    it "returns unprocessable if incorreect credentials" do
      FactoryBot.create(:admin_user, email: "joy@joyofrails.com", password: "password")
      post admin_users_sessions_path, params: {admin_user: {email: "incorrect@joyofrails.com", password: "incorrect"}}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns unprocessable if missing credentials" do
      post admin_users_sessions_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "redirects if already signed in" do
      admin_user = FactoryBot.create(:admin_user, email: "joy@joyofrails.com", password: "password")
      login_admin_user(admin_user)
      FactoryBot.create(:admin_user, email: "another@joyofrails.com", password: "password")

      post admin_users_sessions_path, params: {admin_user: {email: "another@joyofrails.com", password: "password"}}

      expect(response).to have_http_status(:found)
      expect(request.env["warden"].user(scope: :admin_user)).to eq(admin_user)
    end
  end

  describe "DELETE destroy" do
    it "returns http success" do
      delete destroy_admin_users_sessions_path
      expect(response).to have_http_status(302)
    end
  end
end
