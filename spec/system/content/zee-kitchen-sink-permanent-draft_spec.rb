require "rails_helper"

RSpec.describe "Zee Kitchen Sink Permanent Draft", type: :system do
  it "displays the article content" do
    FactoryBot.create(:user, :primary_author)
    Page.upsert_page_by_request_path! "/articles/zee-kitchen-sink-permanent-draft"

    visit "/articles/zee-kitchen-sink-permanent-draft"

    expect(page).to have_content "Zee Kitchen Sink Permanent Draft"

    expect(page).to have_content "How likely are you to use SQLite in your Rails app?"

    within ".poll" do
      click_button "Strongly considering"
    end

    expect(page).to have_content "Thank you for voting!"
  end
end
