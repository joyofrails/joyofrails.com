require "rails_helper"

RSpec.describe "Home", type: :system do
  it "displays the home page" do
    Page.upsert_collection_from_sitepress!

    visit "/"

    expect(document).to have_content("Joy of Rails")
    expect(document).to have_content("More articles")
  end

  it "doesn’t break if an article gets moved" do
    Page.upsert_collection_from_sitepress!

    Page.published.first.update!(request_path: "/articles/new-path")

    visit "/"

    expect(document).to have_content("Joy of Rails")
    expect(document).to have_content("More articles")
  end
end
