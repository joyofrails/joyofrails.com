# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Newsletter subscriptions", type: :system do
  it "allows a user to subscribe to the newsletter" do
    visit root_path

    click_button "Subscribe"
    expect(page).to have_content("Email can't be blank")

    fill_in "user[email]", with: "hello@example.com"
    click_button "Subscribe"

    expect(page).to have_content("You are subscribed to the Joy of Rails newsletter! Please check your email for a confirmation link.")

    user = User.last
    expect(user.email).to eq("hello@example.com")
    expect(user.subscribed_to_newsletter?).to eq(true)
  end

  it "allows a logged-in user to subscribe to the newsletter" do
    user = FactoryBot.create(:user, :unsubscribed)

    login_user(user)

    visit root_path

    click_button "Subscribe"

    expect(page).to have_content("You are subscribed to the Joy of Rails newsletter! Please check your email for a confirmation link.")

    expect(user.reload.subscribed_to_newsletter?).to be_truthy

    visit root_path

    click_link "Manage subscription"

    accept_confirm do
      click_button "Unsubscribe"
    end

    expect(user.reload.subscribed_to_newsletter?).to be_falsey

    # TODO: Implement this as a Turbo Frame with flash
    # https://www.hotrails.dev/turbo-rails/flash-messages-hotwire
    # expect(page).to have_content("You have been unsubscribed from the Joy of Rails newsletter.")
  end
end
