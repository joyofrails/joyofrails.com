require "rails_helper"

RSpec.describe "Examples Counter", type: :system do
  it "maintains a daily click count" do
    visit examples_counters_path

    within "#new_examples_counter" do
      assert_count(0)

      click_button "Increment"

      assert_count(1)

      click_button "Decrement"
      click_button "Decrement"

      assert_count(-1)

      click_button "Increment"
      click_button "Increment"
      click_button "Increment"

      assert_count(2)
    end

    visit examples_counters_path

    within "#new_examples_counter" do
      assert_count(2)

      click_button "Reset"

      assert_count(0)
    end

    visit examples_counters_path

    within "#new_examples_counter" do
      assert_count(0)
    end
  end

  def assert_count(count)
    expect(document).to have_content("Count\n#{count}")
  end
end
