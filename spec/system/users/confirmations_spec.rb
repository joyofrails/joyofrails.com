# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmations", type: :system do
  it "allows a user to confirm their email address" do
    user = FactoryBot.create(:user)
    expect(user).not_to be_confirmed

    EmailConfirmationNotifier.deliver_to(user)
    perform_enqueued_jobs
    perform_enqueued_jobs

    mail = find_mail_to(user.email)

    expect(mail.subject).to eq "Confirm your email address"

    visit email_link(mail, "Confirm my email address")

    click_button "Confirm email"

    expect(page).to have_content("Your account has been confirmed")
    expect(User.last).to be_confirmed
  end
end
