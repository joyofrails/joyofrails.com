require "rails_helper"

RSpec.describe "Examples", type: :system do
  it "shows a list of runnable code examples" do
    visit examples_path

    within "#example_1" do
      expect(page).to have_text(%(puts "Hello, Ruby!"))

      click_button "Run"

      # Allow extra time for wasm to download and initialize
      within ".code-output", wait: 20 do
        expect(page).to have_text("Hello, Ruby!")
      end
    end

    within "#example_2" do
      expect(page).to have_text("[1, 2, 3].map { |n| n * 2 }")

      click_button "Run"

      within ".code-result" do
        expect(page).to have_text("=> 12")
      end
    end
  end
end