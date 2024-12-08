require "rails_helper"

RSpec.describe "What you need to know about SQLite", type: :system do
  it "displays the article content if primary poll author does not exist" do
    visit "/articles/what-you-need-to-know-about-sqlite"

    expect(document).to have_content "What you need to know about SQLite"
  end

  xit "displays the article content with poll by primary author" do
    FactoryBot.create(:user, :primary_author)

    visit "/articles/what-you-need-to-know-about-sqlite"

    expect(document).to have_content "What you need to know about SQLite"

    expect(document).to have_content "How likely are you to use SQLite in your Rails app?"
  end
end
