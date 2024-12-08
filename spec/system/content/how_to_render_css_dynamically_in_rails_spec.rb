require "rails_helper"

RSpec.describe "How to Render CSS Dynamically in Rails", type: :system do
  let(:curated_colors) do
    FactoryBot.create_list(:color_scheme, 3)
  end

  before do
    allow(ColorScheme).to receive(:curated).and_return(curated_colors)
  end

  it "provides a color scheme preview" do
    visit "/articles/how-to-render-css-dynamically-in-rails"

    expect(document).to have_content "How to Render CSS Dynamically in Rails"

    within "#color-scheme-preview" do
      chosen_color = curated_colors.sample
      select chosen_color.display_name, from: "settings[color_scheme_id]"

      expect(document).to have_content("You are now previewing #{chosen_color.display_name}")

      expect(document).to have_css(".color-scheme__#{chosen_color.name.parameterize}")
    end
  end
end
