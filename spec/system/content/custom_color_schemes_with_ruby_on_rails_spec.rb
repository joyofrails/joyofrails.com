# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom Color Schemes with Ruby on Rails", type: :system do
  let(:curated_colors) do
    FactoryBot.create_list(:color_scheme, 3)
  end

  before do
    allow(ColorScheme).to receive(:curated).and_return(curated_colors)
  end

  it "user can selected a curated color scheme" do
    visit "/articles/custom-color-schemes-with-ruby-on-rails"

    expect(document).to have_content "Custom Color Schemes with Ruby on Rails"

    within "#color-scheme-form" do
      chosen_color = curated_colors.sample
      select chosen_color.display_name, from: "settings[color_scheme_id]"

      click_button "Save #{chosen_color.display_name}"

      expect(document).to have_content("You have saved #{chosen_color.display_name} as your personal color scheme.")

      expect(document).to have_css(".color-scheme__#{chosen_color.name.parameterize}")
    end
  end
end
