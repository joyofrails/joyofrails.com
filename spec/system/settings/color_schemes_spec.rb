# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Customize Color Scheme", type: :system do
  it "user can selected a curated color scheme" do
    curated_color_names = YAML.load_file(Rails.root.join("config", "curated_colors.yml")).sample(3)

    curated_colors = curated_color_names.map do |name|
      FactoryBot.create(:color_scheme, name: name)
    end

    visit settings_color_scheme_path

    chosen_color = curated_colors.second
    select chosen_color.display_name, from: "settings[color_scheme_id]"

    click_button "Save this color scheme"

    expect(page).to have_content("You are now using the #{chosen_color.display_name} color scheme")

    expect(page).to have_css(".color-scheme__#{chosen_color.name.parameterize}")
  end
end
