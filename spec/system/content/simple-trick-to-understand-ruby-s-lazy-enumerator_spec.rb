require "rails_helper"

RSpec.describe "A simple trick to understand Ruby’s lazy enumerator", type: :system do
  it "displays the article content" do
    visit "/articles/simple-trick-to-understand-ruby-s-lazy-enumerator"

    expect(document).to have_content "A simple trick to understand Ruby’s lazy enumerator"
  end
end
