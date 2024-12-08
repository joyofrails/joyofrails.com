require "rails_helper"

RSpec.describe "Add your Rails App to the Home Screen", type: :system do
  it "displays the article content" do
    visit "/articles/add-your-rails-app-to-the-home-screen"

    expect(document).to have_content "Add your Rails app to the Home Screen"
  end
end
