require "rails_helper"

RSpec.describe "Sessions", type: :request do
  before do
    Flipper[:user_registration].enable
  end

  describe "GET new" do
    it "succeeds" do
      get new_users_session_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects if authenticated" do
      login_user

      get new_users_session_path

      expect(response).to have_http_status(:found)
    end
  end

  describe "POST create" do
    it "signs in confirmed user with valid email and password" do
      user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")
      expect(user.last_sign_in_at).to be_nil

      post users_sessions_path, params: {user: {email: user.email, password: "password"}}

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Signed in successfully")
      expect(user.reload.last_sign_in_at).to be_present
    end

    it "signs in confirmed user with valid magic session token" do
      user = FactoryBot.create(:user, :confirmed)
      token = user.generate_token_for(:magic_session)
      expect(user.last_sign_in_at).to be_nil

      post users_sessions_path, params: {token: token}

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Signed in successfully")
      expect(user.reload.last_sign_in_at).to be_present
    end

    it "signs in and confirms unconfirmed user with valid magic session token" do
      user = FactoryBot.create(:user, :unconfirmed)
      token = user.generate_token_for(:magic_session)
      expect(user.last_sign_in_at).to be_nil

      post users_sessions_path, params: {token: token}

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Signed in successfully")

      user.reload

      expect(user.last_sign_in_at).to be_present
      expect(user).to be_confirmed

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Welcome to Joy of Rails!")
    end

    it "disallows when user not found with given email" do
      post users_sessions_path, params: {user: {email: "hello#{SecureRandom.hex(5)}@example.com", password: "password"}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to eq("Incorrect email or password")
    end

    it "disallows password sign in when user is not confirmed" do
      user = FactoryBot.create(:user, :unconfirmed, password: "password", password_confirmation: "password")
      post users_sessions_path, params: {user: {email: user.email, password: "password"}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to eq("Please confirm your email address first")
    end

    it "disallows when missing email param" do
      post users_sessions_path, params: {}

      expect(response).to have_http_status(:bad_request)
    end

    it "disallows use of password param for subscriber user" do
      user = FactoryBot.create(:user, :subscribing)

      post users_sessions_path, params: {user: {email: user.email, password: "password"}}

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE destroy" do
    it "signs out user" do
      login_user

      delete destroy_users_sessions_path

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Signed out successfully")
    end

    it "redirects if not signed in" do
      delete destroy_users_sessions_path

      expect(response).to have_http_status(:found)
      expect(flash[:alert]).to eq("You need to sign in to access that page")
    end
  end
end
