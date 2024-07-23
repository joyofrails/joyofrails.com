require "rails_helper"

RSpec.describe "Examples: Posts", type: :system do
  it "renders the form inputs dynamically and retains previously entered values" do
    visit examples_posts_path

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Text (Markdown)")

      expect(page).not_to have_content("Link URL")

      fill_in "Title", with: "My Post 🎸"
      fill_in "Text (Markdown)", with: "# This is a post about guitars 🎸"
    end

    choose "Link"

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Link URL")

      expect(page).not_to have_content("Markdown")

      fill_in "Link URL", with: "https://example.com/link"
    end

    choose "Image"

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Image URL")

      expect(page).not_to have_content("Link URL")

      fill_in "Image URL", with: "https://example.com/image.jpg"
    end

    choose "Text"

    within "form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Markdown")

      expect(page).not_to have_content("Image URL")

      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Text (Markdown)", with: "# This is a post about guitars 🎸")
    end

    choose "Link"

    within "form" do
      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Link URL", with: "https://example.com/link")
    end

    choose "Image"

    within "form" do
      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Image URL", with: "https://example.com/image.jpg")
    end
  end
end
