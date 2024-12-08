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

    expect(document).to have_content("Signed in successfully")

    within "#header_navigation" do
      expect(document).not_to have_content("Subscribe")
      expect(document).to have_content(user.name)
    end
  end

  it "fails sign in" do
    user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")

    visit new_users_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "wrong-password"

    click_button "Sign in"

    expect(current_path).to eq(users_sessions_path)
    expect(document).to have_text("Incorrect email or password")
  end

  it "signs out user" do
    user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")

    login_user(user)

    visit root_path

    within "#header_navigation" do
      expect(document).to have_text(user.name)

      click_link user.name
    end

    click_button "Sign out"

    expect(document).to have_text("Signed out successfully")
    expect(document).not_to have_text(user.name)

    within "#header_navigation" do
      expect(document).to have_text("Subscribe")
    end
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

    expect(document).to have_content("Signed in successfully")
  end
end
