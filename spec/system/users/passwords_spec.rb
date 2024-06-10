# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Passwords", type: :system do
  it "allows a user to reset their password" do
    user = FactoryBot.create(:user, :confirmed)

    visit new_users_password_path

    fill_in "Email address", with: user.email
    click_button "Send me password reset instructions"

    expect(page).to have_content("If that user exists we’ve sent instructions to their email")

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to(user.email)

    expect(mail.subject).to eq "Reset your password"

    visit email_link(mail, "Click here to reset your password")

    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    click_button "Update password"

    expect(page).to have_content("Password updated! Please sign in")
    expect(page.current_path).to eq new_users_session_path

    expect(User.last.authenticate("new_password")).to eq user
  end

  it "handles error when resetting password" do
    user = FactoryBot.create(:user, :confirmed)

    PasswordResetNotifier.deliver_to(user)

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to(user.email)

    visit email_link(mail, "Click here to reset your password")

    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "not_matching_password"
    click_button "Update password"

    expect(page).to have_content("Password confirmation doesn't match Password")

    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    click_button "Update password"

    expect(page).to have_content("Password updated! Please sign in")
    expect(page.current_path).to eq new_users_session_path

    expect(User.last.authenticate("new_password")).to eq user
  end
end
