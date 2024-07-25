require "rails_helper"

RSpec.describe "Examples: Posts", type: :system do
  before do
    user = login_user
    Flipper.enable(:example_posts, user)
  end

  it "renders the form inputs dynamically and retains previously entered values" do
    visit examples_posts_path

    click_link "New Post"

    within "main form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Text (Markdown)")

      expect(page).not_to have_content("Link URL")

      fill_in "Title", with: "My Post 🎸"
      fill_in "Text (Markdown)", with: "# This is a post about guitars 🎸"
    end

    choose "Link"

    within "main form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Link URL")

      expect(page).not_to have_content("Markdown")

      fill_in "Link URL", with: "https://example.com/link"
    end

    choose "Image"

    within "main form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Image URL")

      expect(page).not_to have_content("Link URL")

      fill_in "Image URL", with: "https://example.com/image.jpg"
    end

    choose "Text"

    within "main form" do
      expect(page).to have_content("Title")
      expect(page).to have_content("Markdown")

      expect(page).not_to have_content("Image URL")

      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Text (Markdown)", with: "# This is a post about guitars 🎸")
    end

    choose "Link"

    within "main form" do
      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Link URL", with: "https://example.com/link")
    end

    choose "Image"

    within "main form" do
      expect(page).to have_field("Title", with: "My Post 🎸")
      expect(page).to have_field("Image URL", with: "https://example.com/image.jpg")
    end
  end

  it "creates a new markdown post" do
    visit examples_posts_path

    click_link "New Post"

    within "main form" do
      fill_in "Title", with: "My Post 🎸"
      fill_in "Text (Markdown)", with: "# This is a post about guitars 🎸"

      click_button "Save"
    end

    expect(page).to have_content("My Post 🎸")
    expect(page).to have_content("This is a post about guitars 🎸")
  end

  it "creates a new link post" do
    visit examples_posts_path

    click_link "New Post"

    choose "Link"

    within "main form" do
      fill_in "Title", with: "My Link 🎸"
      fill_in "Link URL", with: "https://example.com/link"

      click_button "Save"
    end

    expect(page).to have_content("My Link 🎸")
    expect(page).to have_css("a[href='https://example.com/link']", text: "https://example.com/link")
  end

  it "creates a new image post" do
    visit examples_posts_path

    click_link "New Post"

    choose "Image"

    within "main form" do
      fill_in "Title", with: "My Image 🎸"
      fill_in "Image URL", with: "https://example.com/image.jpg"

      click_button "Save"
    end

    expect(page).to have_content("My Image 🎸")
    expect(page).to have_css("img[src='https://example.com/image.jpg']")
  end
end
