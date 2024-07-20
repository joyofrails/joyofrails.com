# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmations", type: :system do
  before do
    Flipper[:user_registration].enable
  end

  it "allows a user to confirm their email address" do
    user = FactoryBot.create(:user)
    expect(user).not_to be_confirmed

    EmailConfirmationNotifier.deliver_to(user)

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to(user.email)

    expect(mail.subject).to eq "Confirm your email address"

    visit email_link(mail, "Confirm your email address")

    click_button "Confirm email"

    expect(page).to have_content("Thank you for confirming your email address")
    expect(User.last).to be_confirmed
  end

  it "sends welcome email which allow user to unsubscribe" do
    user = FactoryBot.create(:user, :subscriber)
    user.generate_token_for(:confirmation)

    visit edit_users_confirmation_path(user.generate_token_for(:confirmation))

    click_button "Confirm email"

    expect(user.reload.newsletter_subscription).to be_present

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to(user.email)

    expect(mail.subject).to eq "Welcome to Joy of Rails!"

    visit email_link(mail, "unsubscribe")

    expect(page).to have_content("You have been unsubscribed from the Joy of Rails newsletter")
    expect(user.reload.newsletter_subscription).to be_nil
  end
end
