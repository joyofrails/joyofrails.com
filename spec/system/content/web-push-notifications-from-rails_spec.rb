require "rails_helper"

RSpec.describe "Mastering Custom Configuration in Rails", type: :system do
  it "displays the article content" do
    visit "/articles/web-push-notifications-from-rails"

    expect(page).to have_content "Sending Web Push Notifications from Rails"
  end
end
