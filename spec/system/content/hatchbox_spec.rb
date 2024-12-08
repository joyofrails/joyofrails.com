require "rails_helper"

RSpec.describe "Hatchbox", type: :system do
  it "displays the article content" do
    visit "/deploy/hatchbox"

    expect(document).to have_content "Hatchbox"
  end
end
