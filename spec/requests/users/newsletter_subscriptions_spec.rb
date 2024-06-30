# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Newsletter Subscriptions", type: :request do
  describe "GET new" do
    it "succeeds for signed out user" do
      get new_users_newsletter_subscription_path

      expect(response).to have_http_status(:ok)
    end

    it "succeeds for signed-in unsubscibed user" do
      login_user FactoryBot.create(:user, :unsubscribed)

      get new_users_newsletter_subscription_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET show" do
    it "succeeds for existing subscription" do
      subscription = FactoryBot.create(:newsletter_subscription)
      get users_newsletter_subscription_path(subscription)

      expect(response).to have_http_status(:ok)
    end

    it "fails otherwise" do
      get users_newsletter_subscription_path("not-found")

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET index" do
    it "succeeds for logged in user with subscription" do
      login_user FactoryBot.create(:user, :subscribed)

      get users_newsletter_subscriptions_path

      expect(response).to have_http_status(:ok)
    end

    it "succeeds for logged in user without subscription" do
      login_user FactoryBot.create(:user, :unsubscribed)

      get users_newsletter_subscriptions_path

      expect(response).to have_http_status(:ok)
    end

    it "requires authentication" do
      get users_newsletter_subscriptions_path

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "succeeds for unauthenticated request" do
      email = FactoryBot.generate(:email)

      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: email}}
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(users_newsletter_subscription_path(User.last.newsletter_subscription))

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      user = User.last
      expect(user).not_to be_confirmed
      expect(user.newsletter_subscription).to be_present

      mail = find_mail_to(email)

      expect(mail.subject).to eq "Confirm your email address"
    end

    it "notifies admin for new user" do
      email = FactoryBot.generate(:email)
      admin = FactoryBot.create(:admin_user)

      post users_newsletter_subscriptions_path,
        params: {user: {email: email, password: "password", password_confirmation: "password"}}

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      mail = find_mail_to(admin.email)

      expect(mail.subject).to eq "New Joy of Rails User"
    end

    it "disallows for a subscribing with an already subscribed email" do
      user = FactoryBot.create(:user, :subscriber)

      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: user.email}}
      }.not_to change(NewsletterSubscription, :count)

      expect(response).to redirect_to(users_newsletter_subscription_path(User.last.newsletter_subscription))

      expect(user.reload.newsletter_subscription).to be_present
      # assert "already subscribed" email sent
    end

    it "succeeds for a user with existing account who is not currently subscribed email" do
      user = FactoryBot.create(:user, :unsubscribed)

      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: user.email}}
      }.to change(NewsletterSubscription, :count).by(1)

      expect(response).to redirect_to(users_newsletter_subscription_path(User.last.newsletter_subscription))

      expect(user.reload.newsletter_subscription).to be_present
    end

    it "sends confirmation for an unconfirmed user with existing account who is not currently subscribed email" do
      user = FactoryBot.create(:user, :unsubscribed, :unconfirmed)
      admin = FactoryBot.create(:admin_user)

      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: user.email}}
      }.to change(NewsletterSubscription, :count).by(1)

      expect(response).to redirect_to(users_newsletter_subscription_path(User.last.newsletter_subscription))

      expect(user.reload.newsletter_subscription).to be_present

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      mail = find_mail_to(user.email)

      expect(mail.subject).to eq "Confirm your email address"

      expect(find_mail_to(admin.email)).to be_nil
    end

    it "disallows a user to subscribe with an invalid email" do
      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: "invalid-email"}}
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET unsubscribe" do
    it "unsubscribes a user with an existing subscription and unsubscribe token" do
      expect {
        post users_newsletter_subscriptions_path,
          params: {user: {email: "invalid-email"}}
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST subscribe" do
    it "subscribes unsubscribed, logged-in user" do
      user = FactoryBot.create(:user, :unsubscribed)
      login_user user

      expect(user.newsletter_subscription).to be_nil

      expect {
        post subscribe_users_newsletter_subscriptions_path
      }.to change(NewsletterSubscription, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Success!")

      expect(user.reload.newsletter_subscription).to be_present
    end

    it "sends confirmation email" do
      user = FactoryBot.create(:user, :unconfirmed, :unsubscribed)
      login_user user

      post subscribe_users_newsletter_subscriptions_path

      expect(user.reload.newsletter_subscription).to be_present

      perform_enqueued_jobs_and_subsequently_enqueued_jobs

      mail = find_mail_to(user.email)

      expect(mail.subject).to eq "Confirm your email address"
    end

    it "quietly succeeds for already subscribed user" do
      user = FactoryBot.create(:user, :subscribed)
      login_user user

      expect(user.newsletter_subscription).to be_present

      expect {
        post subscribe_users_newsletter_subscriptions_path
      }.not_to change(NewsletterSubscription, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Success!")

      expect(user.reload.newsletter_subscription).to be_present
    end

    it "disallows for unauthenticated user" do
      expect {
        post subscribe_users_newsletter_subscriptions_path
      }.not_to change(NewsletterSubscription, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST unsubscribe" do
    it "unsubscribes a user with an existing subscription and unsubscribe token via GET" do
      user = FactoryBot.create(:user, :subscribed)
      expect(user.newsletter_subscription).to be_present

      expect {
        get unsubscribe_users_newsletter_subscription_path(user.newsletter_subscription.generate_token_for(:unsubscribe))
      }.to change(NewsletterSubscription, :count).by(-1)

      user.reload

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been unsubscribed")

      expect(user.newsletter_subscription).to be_nil
    end

    it "unsubscribes a user with an existing subscription and unsubscribe token via DELETE" do
      user = FactoryBot.create(:user, :subscribed)
      expect(user.newsletter_subscription).to be_present

      expect {
        delete unsubscribe_users_newsletter_subscription_path(user.newsletter_subscription.generate_token_for(:unsubscribe))
      }.to change(NewsletterSubscription, :count).by(-1)

      user.reload

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been unsubscribed")

      expect(user.newsletter_subscription).to be_nil
    end

    it "unsubscribes a user with an existing subscription and unsubscribe token via POST" do
      user = FactoryBot.create(:user, :subscribed)
      expect(user.newsletter_subscription).to be_present

      expect {
        delete unsubscribe_users_newsletter_subscription_path(user.newsletter_subscription.generate_token_for(:unsubscribe))
      }.to change(NewsletterSubscription, :count).by(-1)

      user.reload

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been unsubscribed")

      expect(user.newsletter_subscription).to be_nil
    end

    it "unsubscribes via POST with List-Unsubscribe=One-Click param per RFC 8058" do
      user = FactoryBot.create(:user, :subscribed)
      expect(user.newsletter_subscription).to be_present

      expect {
        post unsubscribe_users_newsletter_subscription_path(user.newsletter_subscription.generate_token_for(:unsubscribe)),
          params: {"List-Unsubscribe" => "One-Click"}
      }.to change(NewsletterSubscription, :count).by(-1)

      user.reload

      expect(response).to have_http_status(:ok)

      expect(user.newsletter_subscription).to be_nil
    end

    it "disallows for bad token" do
      user = FactoryBot.create(:user, :subscribed)
      expect(user.newsletter_subscription).to be_present

      expect {
        post unsubscribe_users_newsletter_subscription_path(user.newsletter_subscription.id)
      }.not_to change(NewsletterSubscription, :count)

      user.reload

      expect(response).to have_http_status(:not_found)
      expect(user.newsletter_subscription).to be_present
    end

    it "unsubscribes a logged in user with an existing subscription on collection route" do
      user = FactoryBot.create(:user, :subscribed)
      login_user user

      expect(user.newsletter_subscription).to be_present

      expect {
        delete unsubscribe_users_newsletter_subscriptions_path
      }.to change(NewsletterSubscription, :count).by(-1)

      user.reload

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been unsubscribed")

      expect(user.newsletter_subscription).to be_nil
    end

    it "disallows when not logged in on collection route" do
      expect {
        post unsubscribe_users_newsletter_subscriptions_path
      }.not_to change(NewsletterSubscription, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
