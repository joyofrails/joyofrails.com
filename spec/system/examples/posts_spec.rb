require "rails_helper"

RSpec.describe "Examples: Posts", type: :system do
  it "renders the form" do
    visit examples_posts_path

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Markdown")
    end

    click_link "Link"

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Link URL")

      expect(page).not_to have_content("Markdown")
    end

    click_link "Image"

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Image URL")

      expect(page).not_to have_content("Link URL")
    end
  end
end
