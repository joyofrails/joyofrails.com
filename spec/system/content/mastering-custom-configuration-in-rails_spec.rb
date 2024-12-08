require "rails_helper"

RSpec.describe "Mastering Custom Configuration in Rails", type: :system do
  it "displays the article content" do
    visit "/articles/mastering-custom-configuration-in-rails"

    expect(document).to have_content "Mastering Custom Configuration in Rails"
  end
end
