require "rails_helper"

RSpec.describe "What you need to know about SQLite", type: :system do
  it "displays the article content" do
    visit "/articles/what-you-need-to-know-about-sqlite"

    expect(page).to have_content "What you need to know about SQLite"
  end
end
