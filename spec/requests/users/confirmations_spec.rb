# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmations", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "POST create" do
    it "succeeds for unconfirmed user" do
      user = FactoryBot.create(:user, :unconfirmed)

      post users_confirmations_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Check your email for confirmation instructions")

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Confirm your email address")

      expect(user.email_exchanges.all?(&:archived?)).to eq(true)
    end

    it "succeeds for unconfirmed subscriber" do
      user = FactoryBot.create(:user, :unconfirmed, :subscribed)

      post users_confirmations_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Check your email for confirmation instructions")

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Confirm your email address")

      expect(user.email_exchanges.all?(&:archived?)).to eq(true)
    end

    it "disallows when user not found with given email" do
      post users_confirmations_path, params: {user: {email: "hello#{SecureRandom.hex(5)}@example.com"}}

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("We are unable to confirm that email address")
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "disallows when user is already confirmed" do
      user = FactoryBot.create(:user, :confirmed)
      post users_confirmations_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Your account has already been confirmed")
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "disallows when missing email param" do
      post users_confirmations_path, params: {}

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET edit" do
    it "succeeds for unconfirmed user with valid token" do
      user = FactoryBot.create(:user, :unconfirmed)

      get edit_users_confirmation_path(user.generate_token_for(:confirmation))

      expect(response).to have_http_status(:ok)
    end

    it "disallows a user to confirm email address with invalid token" do
      get edit_users_confirmation_path("invalid_token")

      expect(response).to redirect_to(new_users_confirmation_path)

      expect(flash[:alert]).to eq("This link is invalid or expired")
    end

    it "disallows an already confirmed user" do
      user = FactoryBot.create(:user, :confirmed)

      get edit_users_confirmation_path(user.generate_token_for(:confirmation))

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Your account has already been confirmed")
    end
  end

  describe "PUT update" do
    it "succeeds for unconfirmed user with valid token" do
      user = FactoryBot.create(:user, :unconfirmed)

      put users_confirmation_path(user.generate_token_for(:confirmation))

      expect(response).to redirect_to(users_thank_you_path)
      expect(flash[:notice]).to eq("Thank you for confirming your email address")
    end

    it "works when user sessions are disabled" do
      Flipper[:user_registration].enable

      user = FactoryBot.create(:user, :unconfirmed)

      put users_confirmation_path(user.generate_token_for(:confirmation))

      expect(response).to redirect_to(users_thank_you_path)
      expect(flash[:notice]).to eq("Thank you for confirming your email address")
    end

    it "sends welcome email to user" do
      user = FactoryBot.create(:user, :unconfirmed)

      put users_confirmation_path(user.generate_token_for(:confirmation))

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Welcome to Joy of Rails!")
    end

    it "disallows a user to confirm their email address with invalid token" do
      token = "invalid_token"

      put users_confirmation_path(token)

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("That link is invalid or expired")
    end

    it "disallows a user to confirm their email address with expired token" do
      user = FactoryBot.create(:user, :unconfirmed)
      token = user.generate_token_for(:confirmation)

      travel_to 7.hours.from_now

      put users_confirmation_path(token)

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("That link is invalid or expired")
    end

    it "disallows a user to confirm their email address with already confirmed email address" do
      user = FactoryBot.create(:user, :confirmed)

      put users_confirmation_path(user.generate_token_for(:confirmation))

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Your account has already been confirmed")
    end
  end
end
