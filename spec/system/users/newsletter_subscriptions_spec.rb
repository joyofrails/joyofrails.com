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
  end
end
