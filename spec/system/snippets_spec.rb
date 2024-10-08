require "rails_helper"

RSpec.describe "Snippets", type: :system do
  before do
    Flipper.enable(:snippets)
  end

  it "can creat and edit a snippet" do
    login_as_user

    visit share_snippets_path

    click_link "New Snippet"

    fill_in "snippet[filename]", with: "app/models/blog.rb"
    select "Ruby", from: "Language"

    find(".code-editor").click

    fill_in "snippet[source]", with: "class Blog\nend"

    click_button "Save"

    expect(page).to have_content("Your snippet has been saved")

    snippet = Snippet.last
    expect(snippet.source).to eq("class Blog\nend")
    expect(snippet.language).to eq("ruby")
    expect(snippet.filename).to eq("app/models/blog.rb")

    fill_in "snippet[filename]", with: "lib/models/blog.rb"

    find(".code-editor").click
    fill_in "snippet[source]", with: "class Blog\n  has_many :posts\nend"

    click_button "Save"

    expect(page).to have_content("Your snippet has been saved")

    click_link "Back to snippets"

    expect(page).to have_content("lib/models/blog.rb")
    expect(page).to have_content("class Blog\n  has_many :posts\nend")
  end

  it "can attach a screenshot" do
    snippet = FactoryBot.create(:snippet, author: login_as_user)

    visit share_snippet_path(snippet)

    click_link "Share"

    expect(page).to have_content("Download")
  end

  it "can share Snippet" do
    FactoryBot.create(:snippet, filename: "example.rb", author: login_as_user)

    visit share_snippets_path

    within("#snippets") do
      expect(page).to have_content("example.rb")
      click_link "Share"
    end

    expect(page).to have_content("Download")
    click_link "Download"
  end
end
