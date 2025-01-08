require "rails_helper"

RSpec.describe "A simple trick to understand Ruby’s lazy enumerator", type: :system do
  it "displays the article content" do
    visit "/articles/simple-trick-to-understand-ruby-lazy-enumerator"

    expect(document).to have_content "A simple trick to understand Ruby’s lazy enumerator"
  end

  it "displays the article content with poll by primary author" do
    FactoryBot.create(:user, :primary_author)

    visit "/articles/simple-trick-to-understand-ruby-lazy-enumerator"

    expect(document).to have_content "Lazy Enumerator Live Poll"

    expect(document).to have_content "How often do you reach for Ruby’s lazy enumerator?"
  end
end
