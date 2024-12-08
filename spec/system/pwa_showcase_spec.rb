require "rails_helper"

RSpec.describe "PWA Showcase", type: :system do
  it "hides PWA Showcase navigation" do
    visit "/"

    expect(document).not_to have_link("Progress Web Apps on Rails Showcase")
  end

  it "renders the Install to Homescreen button" do
    visit "/pwa-showcase"

    expect(document).to have_button("Install to Homescreen", disabled: true)
  end

  # To run the following test, add selenium-webdriver to Gemfile
  #
  # context "firefox" do
  #   before do
  #     driven_by(:selenium, using: :headless_firefox)
  #   end

  #   it "renders the Install to Homescreen button" do
  #     visit "/pwa-showcase"

  #     click_link "Install to Homescreen"

  #     expect(document).to have_content("PWA installation is not currently supported in Firefox on desktop.")
  #   end
  # end
end
