require "rails_helper"

RSpec.describe "Articles", type: :system do
  it "displays articles" do
    visit "/articles"

    expect(page).to have_content("Articles")
  end
end
