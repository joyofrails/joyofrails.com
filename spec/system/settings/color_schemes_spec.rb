# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Customize Color Scheme", type: :system do
  let(:curated_colors) do
    curated_color_names = YAML.load_file(Rails.root.join("config", "curated_colors.yml")).sample(3)

    curated_color_names.map do |name|
      FactoryBot.create(:color_scheme, name: name)
    end
  end

  before { curated_colors }

  it "user can selected a curated color scheme" do
    visit settings_color_scheme_path

    chosen_color = curated_colors.sample
    select chosen_color.display_name, from: "settings[color_scheme_id]"

    click_button "Save #{chosen_color.display_name}"

    expect(page).to have_content("You are now using the #{chosen_color.display_name} color scheme")

    expect(page).to have_css(".color-scheme__#{chosen_color.name.parameterize}")
  end
end
