# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  before do
    Flipper[:user_registration].enable
  end

  describe "GET create" do
    it "succeeds for signed out user" do
      get new_users_registration_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects for signed in user" do
      login_user

      get new_users_registration_path

      expect(response).to redirect_to(users_dashboard_path)
    end
  end

  describe "POST create" do
    it "succeeds for unauthenticated request" do
      email = FactoryBot.generate(:email)
      expect {
        post users_registration_path,
          params: {user: {email: email, password: "password", password_confirmation: "password"}}
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Welcome to Joy of Rails! Please check your email for confirmation instructions")

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(User.last).not_to be_confirmed

      mail = find_mail_to(email)

      expect(mail.subject).to eq "Confirm your email address"
    end

    it "disallows a user to subscribe with existing email" do
      user = FactoryBot.create(:user)

      expect {
        post users_registration_path,
          params: {user: {email: user.email, password: "password", password_confirmation: "password"}}
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "disallows when missing email param" do
      expect {
        post users_registration_path, params: {password: "password", password_confirmation: "password"}
      }.not_to change(User, :count)

      expect(response).to have_http_status(:bad_request)
    end

    it "disallows when missing password confirmation param" do
      expect {
        post users_registration_path, params: {email: FactoryBot.generate(:email), password: "password"}
      }.not_to change(User, :count)

      expect(response).to have_http_status(:bad_request)
    end

    it "disallows for signed in user" do
      login_user

      expect {
        post users_registration_path,
          params: {user: {email: FactoryBot.generate(:email), password: "password", password_confirmation: "password"}}
      }.not_to change(User, :count)

      expect(response).to redirect_to(users_dashboard_path)
    end

    it "disallows if feature is disabled" do
      Flipper[:user_registration].disable

      expect {
        post users_registration_path,
          params: {user: {email: FactoryBot.generate(:email), password: "password", password_confirmation: "password"}}
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq "Coming soon!"
    end
  end

  describe "GET edit" do
    it "succeeds for confirmed user with valid token" do
      user = FactoryBot.create(:user, :confirmed)

      login_user(user)

      get edit_users_registration_path

      expect(response).to have_http_status(:ok)
    end

    it "disallows for unauthenticated user" do
      FactoryBot.create(:user)

      get edit_users_registration_path

      expect(response).to redirect_to(new_users_session_path)
    end
  end

  describe "PUT update" do
    it "succeeds for signed in user with password change" do
      user = FactoryBot.create(:user, :confirmed)

      login_user(user)

      put users_registration_path,
        params: {user: {password_challenge: "password", password: "newpassword", password_confirmation: "newpassword"}}

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Account updated")
    end

    it "succeeds for signed in user with email exchange" do
      user = FactoryBot.create(:user, :confirmed)

      login_user(user)

      new_email = FactoryBot.generate(:email)

      expect {
        put users_registration_path,
          params: {user: {password_challenge: "password", email_exchanges_attributes: [{email: new_email}]}}
      }.to change(user.email_exchanges, :count).by(1)

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Check your email for confirmation instructions")

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      mail = find_mail_to(new_email)

      expect(mail.subject).to eq "Confirm your email address"
    end

    it "disallows without current password" do
      user = FactoryBot.create(:user, :confirmed)
      login_user(user)

      put users_registration_path,
        params: {user: {email_exchanges_attributes: {email: FactoryBot.generate(:email)}}}

      expect(flash.now[:error]).to eq("Incorrect password")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
