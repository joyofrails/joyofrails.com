# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Customize Syntax Highlighting", type: :system do
  it "user can selected a curated syntax highlight" do
    visit root_path

    click_link "Syntax Highlighting"

    expect(page).to have_content("Choose a syntax highlight style to preview")
    expect(page).to have_content("Current syntax highlight style: Dracula")

    select "Fruity", from: "settings[syntax_highlight_name]"

    expect(page).to have_content("Current syntax highlight style: Fruity")
    expect(page).not_to have_content("Current syntax highlight style: Dracula")

    expect(page).to have_css("link[data-syntax-highlight*=fruity]", visible: false)
  end
end
