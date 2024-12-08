require "rails_helper"

RSpec.describe "Snippets", type: :system do
  before do
    Flipper.enable(:snippets)
  end

  it "can attach a screenshot" do
    snippet = FactoryBot.create(:snippet, author: login_as_user)

    visit share_snippet_path(snippet)

    click_link "Share"

    expect(document).to have_content("Download")
  end

  it "can share Snippet" do
    FactoryBot.create(:snippet, filename: "example.rb", author: login_as_user)

    visit share_snippets_path

    within("#snippets") do
      expect(document).to have_content("example.rb")
      click_link "Share"
    end

    expect(document).to have_content("Download")
    click_link "Download"
  end
end
