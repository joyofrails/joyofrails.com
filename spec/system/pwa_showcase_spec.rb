require "rails_helper"

RSpec.describe "PWA Showcase", type: :system do
  it "hides PWA Showcase navigation" do
    visit "/"

    expect(page).not_to have_link("Progress Web Apps on Rails Showcase")
  end

  it "renders the Install to Homescreen button" do
    Flipper.enable(:pwa_showcase_navigation)

    visit "/"

    click_link "Progress Web Apps on Rails Showcase"

    expect(page).to have_button("Install to Homescreen")
  end

  context "firefox" do
    before do
      driven_by(:selenium, using: :headless_firefox)
    end

    it "renders the Install to Homescreen button" do
      Flipper.enable(:pwa_showcase_navigation)

      visit "/"

      click_link "Progress Web Apps on Rails Showcase"
      click_link "Install to Homescreen"

      expect(page).to have_content("PWA installation is not currently supported in Firefox on desktop.")
    end
  end
end
