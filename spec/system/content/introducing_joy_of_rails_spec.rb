require "rails_helper"

RSpec.describe "Introducing Joy of Rails", type: :system do
  it "displays the article content" do
    visit "/articles/introducing-joy-of-rails"

    expect(document).to have_content "Introducing Joy of Rails"

    page.driver.scroll_to(0, -10000)
    within "#new_examples_counter" do
      expect(document).to have_content("Count\n0")

      click_button "Increment"

      expect(document).to have_content("Count\n1")
    end
  end
end
