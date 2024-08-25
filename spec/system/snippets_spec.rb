require "rails_helper"

RSpec.describe "Snippets", type: :system do
  before do
    Flipper.enable(:snippets)
  end

  it "can creat and edit a snippet" do
    login_as_user

    visit snippets_path

    click_link "New snippet"

    fill_in "snippet[filename]", with: "app/models/user.rb"
    select "Ruby", from: "Language"

    find("[data-controller=snippet-editor]").click

    fill_in "snippet[source]", with: "class User\nend"

    click_button "Create Snippet"

    expect(page).to have_content("Snippet was successfully created.")

    snippet = Snippet.last
    expect(snippet.source).to eq("class User\nend")
    expect(snippet.language).to eq("ruby")
    expect(snippet.filename).to eq("app/models/user.rb")

    click_link "Edit"

    fill_in "snippet[filename]", with: "app/models/admin_user.rb"

    find("[data-controller=snippet-editor]").click
    fill_in "snippet[source]", with: "class User\n  has_many :posts\nend"

    click_button "Update Snippet"

    expect(page).to have_content("Snippet was successfully updated.")

    snippet.reload
    expect(snippet.source).to eq("class User\n  has_many :posts\nend")
    expect(snippet.language).to eq("ruby")
    expect(snippet.filename).to eq("app/models/admin_user.rb")
  end
end
