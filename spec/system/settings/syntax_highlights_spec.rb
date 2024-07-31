# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Customize Syntax Highlighting", type: :system do
  it "user can selected a curated syntax highlight" do
    visit root_path

    click_link "Syntax Highlighting"

    expect(page).to have_css("link[data-syntax-highlight*=dracula]", visible: false)

    expect(page).to have_content("Choose another syntax highlighting theme to preview")

    select "Fruity", from: "settings[syntax_highlight_name]"

    expect(page).to have_content("You are currently previewing Fruity as your syntax highlighting theme")
    expect(page).not_to have_content("currently previewing Dracula")

    expect(page).to have_css("link[data-syntax-highlight*=fruity]", visible: false)

    click_button "Save Fruity"

    expect(page).to have_content("You have saved Fruity for syntax highlighting across the site")
    expect(page).to have_css("link[data-syntax-highlight*=fruity]", visible: false)
  end
end
