require "rails_helper"

RSpec.describe "Admin for Newsletters", type: :system do
  it "create and send a newsletter" do
    login_as_admin

    visit admin_newsletters_path

    click_on "New Newsletter"

    fill_in "Title", with: "Welcome to Joy of Rails!"

    fill_in "Body", with: <<~MARKDOWN
      # Welcome to the newsletter

      This is the first newsletter.
    MARKDOWN

    click_button "Save Newsletter"

    expect(page).to have_content("Newsletter was successfully created.")

    expect(page).to have_content("Welcome to Joy of Rails!")

    click_on "Send Test"

    click_on "Send Live"
  end
end
