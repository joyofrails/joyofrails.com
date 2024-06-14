# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :system do
  before do
    Flipper[:user_registration].enable
  end

  it "allows a confirmed user to sign in" do
    user = FactoryBot.create(:user, :confirmed, password: "password", password_confirmation: "password")

    visit new_users_session_path

    fill_in "Email address", with: user.email
    fill_in "Password", with: "password"

    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end
end
