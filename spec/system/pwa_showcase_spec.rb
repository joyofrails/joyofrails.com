require "rails_helper"

RSpec.describe "PWA Showcase", type: :system do
  it "renders the Install to Homescreen button" do
    visit "/pwa-showcase"

    expect(page).to have_button("Install to Homescreen")
  end

  context "firefox" do
    before do
      driven_by(:selenium, using: :headless_firefox)
    end

    it "renders the Install to Homescreen button" do
      visit "/pwa-showcase"

      click_link "Install to Homescreen"

      expect(page).to have_content("PWA installation is not currently supported in Firefox.")
    end
  end
end
