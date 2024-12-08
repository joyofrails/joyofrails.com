require "rails_helper"

RSpec.describe "Snippets", type: :system do
  before do
    Flipper.enable(:snippets)
  end

  it "can create and edit a snippet" do
    login_as_user

    visit author_snippets_path

    click_link "New Snippet"

    fill_in "snippet[filename]", with: "app/models/blog.rb"
    select "Ruby", from: "Language"

    find(".code-editor").click

    fill_in "snippet[source]", with: "class Blog\nend"
    fill_in "snippet[title]", with: "A Ruby class"
    fill_in "snippet[description]", with: "This is how you do it"

    click_button "Save"

    expect(document).to have_content("Your snippet has been saved")

    snippet = Snippet.last
    expect(snippet.source).to eq("class Blog\nend")
    expect(snippet.language).to eq("ruby")
    expect(snippet.filename).to eq("app/models/blog.rb")
    expect(snippet.title).to eq("A Ruby class")
    expect(snippet.description).to eq("This is how you do it")

    fill_in "snippet[filename]", with: "lib/models/blog.rb"

    find(".code-editor").click
    fill_in "snippet[source]", with: "class Blog\n  has_many :posts\nend"

    click_button "Save"

    expect(document).to have_content("Your snippet has been saved")

    click_link "Author snippets"

    expect(document).to have_content("lib/models/blog.rb")
    expect(document).to have_content("class Blog\n  has_many :posts\nend")
    expect(document).to have_content("A Ruby class")
    expect(document).to have_content("This is how you do it")
  end
end
