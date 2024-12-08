# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :system do
  before do
    Flipper[:user_registration].enable
  end

  it "allows a new user to register for an account" do
    visit new_users_registration_path

    fill_in "Email address", with: "user1@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(document).to have_content("Welcome to Joy of Rails! Please check your email for confirmation instructions")

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    expect(User.last).not_to be_confirmed

    mail = find_mail_to("user1@example.com")

    expect(mail.subject).to eq "Confirm your email address"
  end

  it "disallows a user to register with existing email" do
    FactoryBot.create(:user, email: "user1@example.com")
    user_count = User.count

    visit new_users_registration_path

    fill_in "Email address", with: "user1@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(document).to have_content("Email has already been taken")

    expect(User.count).to eq(user_count)
  end

  it "allows logged in user to update their account" do
    user = FactoryBot.create(:user, email: "hello@example.com", password: "password", password_confirmation: "password")

    login_user(user)

    visit edit_users_registration_path

    fill_in "Current password", with: "password"

    fill_in "Change email address", with: "newemail@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"

    click_button "Update account"

    expect(document).to have_content("Check your email for confirmation instructions")
    user = User.last
    expect(user.email).to eq("hello@example.com") # not yet updated
    expect(user.email_exchanges.last.email).to eq("newemail@example.com")
    expect(User.authenticate_by(email: "hello@example.com", password: "newpassword")).to eq(user)

    perform_enqueued_jobs_and_subsequently_enqueued_jobs

    mail = find_mail_to("newemail@example.com")

    expect(mail.subject).to eq "Confirm your email address"

    visit email_link(mail, "Confirm your email address")

    user = User.last
    expect(user).to be_confirmed
    expect(user.email).to eq("newemail@example.com")
  end
end
