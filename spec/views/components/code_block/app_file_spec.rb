require "rails_helper"

RSpec.describe CodeBlock::AppFile, type: :view do
  def render_page(*, **)
    Capybara.string(render(*, **))
  end

  before do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end

  it "renders contents of file" do
    page = render_page(CodeBlock::AppFile.new("config/database.yml"))
    expect(page).to have_content(<<~YAML)
      default: &default
        adapter: sqlite3
    YAML
    expect(page).to have_content("config/database.yml")
  end

  it "renders contents of file by line number" do
    page = render_page(CodeBlock::AppFile.new("config/database.yml", lines: 7))
    expect(page).to have_content(<<~YAML.strip)
      default: &default
    YAML

    expect(page).not_to have_content("database: storage/production/data.sqlite3")
  end

  it "renders contents of file by line number range" do
    page = render_page(CodeBlock::AppFile.new("config/database.yml", lines: [7..8]))
    expect(page).to have_content(<<~YAML.strip)
      default: &default
        adapter: sqlite3
    YAML

    expect(page).not_to have_content("database: storage/production/data.sqlite3")
  end

  it "renders contents of file by heterogeneous line number collection" do
    page = render_page(CodeBlock::AppFile.new("config/database.yml", lines: [7..8, 60]))
    expect(page).to have_content(<<~YAML.strip)
      default: &default
        adapter: sqlite3
    YAML

    expect(page).to have_content("database: storage/production/data.sqlite3")
    expect(page).not_to have_content("database: storage/development/data.sqlite3")
  end

  it "renders basic code block when content type is atom" do
    allow(view).to receive(:headers).and_return({"Content-Type" => "application/atom+xml"})

    page = render_page(CodeBlock::AppFile.new("config/database.yml"))
    expect(page).to have_content(<<~YAML)
      default: &default
        adapter: sqlite3
    YAML

    expect(page).not_to have_content("config/database.yml")
  end
end
