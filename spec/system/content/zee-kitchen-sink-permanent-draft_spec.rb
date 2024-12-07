require "rails_helper"

RSpec.describe "Zee Kitchen Sink Permanent Draft", type: :system do
  it "displays the article content" do
    visit "/articles/zee-kitchen-sink-permanent-draft"

    expect(page).to have_content Zee Kitchen Sink Permanent Draft
  end
end
