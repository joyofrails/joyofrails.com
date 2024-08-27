require "rails_helper"

RSpec.describe "Examples", :slow, type: :system do
  it "shows an example" do
    visit example_path("hello_ruby")

    click_button "Run"

    expect(page).to have_text("Just a moment...")

    # Allow extra time for wasm to download and initialize
    within ".code-output", wait: 10 do
      expect(page).to have_text("Hello, Ruby!")
    end
  end

  it "shows a list of runnable code examples" do
    visit examples_path

    within "#example_hello_ruby" do
      expect(page).to have_text(%(puts "Hello, Ruby!"))

      click_button "Run"

      expect(page).to have_text("Just a moment...")

      # Allow extra time for wasm to download and initialize
      within ".code-output", wait: 10 do
        expect(page).to have_text("Hello, Ruby!")
      end
    end

    within "#example_map_sum" do
      expect(page).to have_text("[1, 2, 3].map { |n| n * 2 }")

      click_button "Run"

      within ".code-result" do
        expect(page).to have_text("=> 12")
      end
    end
  end
end
