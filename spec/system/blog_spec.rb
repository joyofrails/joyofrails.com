require "rails_helper"

RSpec.describe "Blog", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays blog" do
    visit "/blog"

    expect(page).to have_content("Hello world")
  end
end
