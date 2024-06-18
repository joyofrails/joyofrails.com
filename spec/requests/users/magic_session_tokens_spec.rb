# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Magic Sessions", type: :request do
  before do
    Flipper[:user_registration].enable
  end

  describe "GET new" do
    it "succeeds" do
      get new_users_magic_session_token_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects if authenticated" do
      login_user

      get new_users_magic_session_token_path

      expect(response).to have_http_status(:found)
    end
  end

  describe "POST create" do
    it "succeeds" do
      user = FactoryBot.create(:user, :confirmed)
      post users_magic_session_tokens_path, params: {user: {email: user.email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("We’ve sent an email with instructions to sign in")

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(user.email)
      expect(mail.subject).to eq("Your sign-in link")
    end

    it "sends an different email when user not found with given email" do
      email = "hello#{SecureRandom.hex(5)}@example.com"
      post users_magic_session_tokens_path, params: {user: {email: email}}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("We’ve sent an email with instructions to sign in")

      perform_enqueued_jobs

      expect(ActionMailer::Base.deliveries.count).to eq(1)

      mail = find_mail_to(email)
      expect(mail.subject).to eq("No account found")
    end
  end
end
