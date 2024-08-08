require "rails_helper"

RSpec.describe "Admin for Newsletters", type: :system do
  it "create and edit a newsletter" do
    login_as_admin

    visit admin_newsletters_path

    click_on "New newsletter"

    fill_in "Title", with: "Welcome to Joy of Rails!"

    fill_in "Content", with: <<~MARKDOWN
      # Welcome to the newsletter

      This is the first newsletter.
    MARKDOWN

    click_button "Create Newsletter"

    expect(page).to have_content("Newsletter was successfully created.")

    expect(page).to have_content("Welcome to Joy of Rails!")

    click_link "Back to newsletters"

    expect(page).to have_content("Welcome to Joy of Rails!")

    within "#newsletters" do
      click_link "Edit"
    end

    fill_in "Content", with: <<~MARKDOWN
      # Welcome to the newsletter

      OMG! This is the first newsletter.
    MARKDOWN

    click_button "Update Newsletter"

    expect(page).to have_content("Newsletter was successfully updated.")

    expect(page).to have_content("OMG! This is the first newsletter.")
  end
end
