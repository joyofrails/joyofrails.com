require "rails_helper"

RSpec.describe "Articles", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays articles" do
    visit "/articles"

    expect(page).to have_content("Hello world")
  end
end
