require "rails_helper"

RSpec.describe "Add a Rails App to the Home Screen", type: :system do
  it "displays the article content" do
    visit "/articles/add-a-rails-app-to-the-home-screen"

    expect(page).to have_content "Add your Rails app to the Home Screen"
  end
end
