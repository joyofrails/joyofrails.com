require "rails_helper"

RSpec.describe "AdminUser sessions", type: :system do
  it "signs in admin_user" do
    admin_user = FactoryBot.create(:admin_user)

    visit new_admin_users_session_path
    expect(document).to have_text("Sign in to your Admin Account")

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"

    click_button "Sign in"

    expect(document).not_to have_text("Sign in to your Admin Account")

    expect(document).to have_text("Signed in successfully.")

    within "main" do
      expect(document).to have_text("Admin")
      expect(document).to have_text("Mission Control")
    end
  end

  it "fails sign in" do
    user = FactoryBot.create(:admin_user)

    visit new_admin_users_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "wrong-password"

    click_button "Sign in"

    expect(current_path).to eq(admin_users_sessions_path)
    expect(document).to have_text("Incorrect email or password.")
  end

  it "signs out admin_user" do
    admin_user = FactoryBot.create(:admin_user)

    login_admin_user(admin_user)

    visit root_path

    within "#header_navigation" do
      click_link "Admin"
    end

    click_button "Sign out"

    expect(document).to have_text("Signed out successfully.")
    expect(document).not_to have_text("Admin")
  end
end
