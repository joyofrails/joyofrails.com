# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Passwords", type: :request do
  describe "GET new" do
    it "succeeds" do
      get new_users_password_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects if authenticated" do
      login_user

      get new_users_password_path

      expect(response).to have_http_status(:found)
    end
  end

  describe "POST create" do
    it "succeeds" do
      user = FactoryBot.create(:user, :confirmed)
      post users_passwords_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(new_users_session_path)
      expect(flash[:notice]).to eq("If that user exists we’ve sent instructions to their email")

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Reset your password")
    end

    it "disallows when user not found with given email" do
      post users_passwords_path, params: {user: {email: "hello#{SecureRandom.hex(5)}@example.com"}}

      expect(response).to redirect_to(new_users_session_path)
      expect(flash[:notice]).to eq("If that user exists we’ve sent instructions to their email") # Don't leak that we don't have that email address
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "disallows when user is not confirmed" do
      user = FactoryBot.create(:user, :unconfirmed)
      post users_passwords_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("Please confirm your email first")
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "disallows when missing email param" do
      post users_passwords_path, params: {}

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET edit" do
    it "succeeds for confirmed user with valid token" do
      user = FactoryBot.create(:user, :confirmed)

      get edit_users_password_path(user.generate_token_for(:password_reset))

      expect(response).to have_http_status(:ok)
    end

    it "disallows a user to reset password with invalid token" do
      get edit_users_password_path("invalid_token")

      expect(response).to redirect_to(new_users_password_path)

      expect(flash[:alert]).to eq("That link is invalid or expired")
    end

    it "disallows an unconfirmed user" do
      user = FactoryBot.create(:user, :unconfirmed)

      get edit_users_password_path(user.generate_token_for(:password_reset))

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("You must confirm your email before you can sign in")
    end
  end

  describe "PUT update" do
    it "succeeds for confirmed user with valid token and params" do
      user = FactoryBot.create(:user, :confirmed)

      put users_password_path(user.generate_token_for(:password_reset)),
        params: {user: {password: "new_password", password_confirmation: "new_password"}}

      expect(response).to redirect_to(new_users_session_path)
      expect(flash[:notice]).to eq("Password updated! Please sign in")
    end

    it "disallows a user with invalid token" do
      token = "invalid_token"

      put users_password_path(token),
        params: {user: {password: "new_password", password_confirmation: "new_password"}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to eq("That link is invalid or expired")
    end

    it "disallows a user with unconfirmed email address" do
      user = FactoryBot.create(:user, :unconfirmed)

      put users_password_path(user.generate_token_for(:password_reset)),
        params: {user: {password: "new_password", password_confirmation: "new_password"}}

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("Please confirm your email before you can sign in")
    end

    it "has validation errors" do
      user = FactoryBot.create(:user, :confirmed)

      put users_password_path(user.generate_token_for(:password_reset)),
        params: {user: {password: "new_password", password_confirmation: "not_matching_password"}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to eq("Password confirmation doesn't match Password")
    end
  end
end
