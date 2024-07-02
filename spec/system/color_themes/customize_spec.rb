# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Customize Color Themes", type: :system do
  it "user can selected a curated color scale" do
    visit color_theme_path

    select "Thunderbird", from: "Choose a color scheme"

    click_button "Use this color scheme"

    expect(page).to have_content("You are now using the Cerulean Blue color scheme")

    expect(page).to have_css("color-theme:custom-thunderbird")
  end
end
