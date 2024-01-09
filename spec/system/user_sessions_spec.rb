require "rails_helper"

RSpec.describe "User sessions", type: :system do
  it "signs in user" do
    user = FactoryBot.create(:user)

    visit new_users_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"

    click_button "Sign in"

    expect(page).to have_text("Signed in successfully.")

    expect(page).to have_text(user.email)
  end
end
