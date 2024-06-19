# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :system do
  before do
    Flipper[:user_registration].enable
  end

  it "allows a confirmed user to sign in by password" do
    user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")

    visit new_users_session_path

    fill_in "Email address", with: user.email
    fill_in "Password", with: "password"

    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end

  it "allows a confirmed user to sign in by magic session token" do
    user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")

    visit new_users_session_path

    click_link "sign in without a password instead"

    fill_in "Email address", with: user.email

    click_button "Send me a magic link"

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to(user.email)

    expect(mail.subject).to eq "Your sign-in link"

    visit email_link(mail, "Click here to sign in")

    click_button "Sign in now"

    expect(page).to have_content("Signed in successfully")
  end
end
