# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :system do
  it "allows a new user to register for an account" do
    visit new_users_registration_path

    fill_in "Email address", with: "user1@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Welcome to Joy of Rails! Please check your email for confirmation instructions.")

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

    expect(page).to have_content("Email has already been taken")

    expect(User.count).to eq(user_count)
  end
end
