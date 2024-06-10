# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmations", type: :system do
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
end
