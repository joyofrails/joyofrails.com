# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmations", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "create" do
    it "succeeds" do
      user = FactoryBot.create(:user, :unconfirmed)

      post users_confirmations_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Check your email for confirmation instructions")

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Confirm your email address")
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

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("We are unable to confirm that email address")
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  describe "update" do
    it "succeeds" do
      user = FactoryBot.create(:user, :unconfirmed)
      token = user.generate_token_for(:confirmation)

      put users_confirmation_path(confirmation_token: token)

      expect(response).to redirect_to(users_dashboard_path)
      expect(flash[:notice]).to eq("Thank you for confirming your email address")
    end

    it "disallows a user to confirm their email address with invalid token" do
      token = "invalid_token"

      put users_confirmation_path(confirmation_token: token)

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("Invalid token")
    end

    it "disallows a user to confirm their email address with expired token" do
      user = FactoryBot.create(:user, :unconfirmed)
      token = user.generate_token_for(:confirmation)

      travel_to 7.hours.from_now

      put users_confirmation_path(confirmation_token: token)

      expect(response).to redirect_to(new_users_confirmation_path)
      expect(flash[:alert]).to eq("Invalid token")
    end

    it "disallows a user to confirm their email address with already confirmed email address" do
      user = FactoryBot.create(:user, :confirmed)
      token = user.generate_token_for(:confirmation)

      put users_confirmation_path(confirmation_token: token)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Your account has already been confirmed")
    end
  end
end
