require "rails_helper"

RSpec.describe "PWA Showcase", type: :system do
  it "renders the Install to Homescreen button" do
    visit "/pwa-showcase"

    expect(page).to have_button("Install to Homescreen")
  end
end
