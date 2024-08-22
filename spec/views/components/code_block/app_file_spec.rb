require "rails_helper"

RSpec.describe CodeBlock::AppFile, type: :view do
  def render_page(*, **)
    Capybara.string(render(*, **))
  end

  before do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end

  it "renders contents of file" do
    page = render_page(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb"))
    expect(page).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
        def add(m, n)
          m + n
        end
      end
    RUBY
    expect(page).to have_content("spec/fixtures/code_block/app_file/example.rb")
  end

  it "renders contents of file by line number" do
    page = render_page(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: 2))
    expect(page).to have_content(<<~RUBY.strip)
      def add(m, n)
    RUBY

    expect(page).not_to have_content("class FixturesCodeBlockAppFileExample")
  end

  it "renders contents of file by line number range" do
    page = render_page(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: [2..4]))

    expect(page).to have_content("def add(m, n)\n    m + n\n  end")
    expect(page).not_to have_content("class FixturesCodeBlockAppFileExample")
  end

  it "renders contents of file by heterogeneous line number collection" do
    page = render_page(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: [1, 3..5]))
    expect(page).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
          m + n
        end
      end
    RUBY
  end

  it "renders basic code block when content type is atom" do
    allow(view).to receive(:headers).and_return({"Content-Type" => "application/atom+xml"})

    page = render_page(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb"))
    expect(page).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
        def add(m, n)
          m + n
        end
      end
    RUBY

    expect(page).not_to have_content("spec/fixtures/code_block/app_file/example.rb")
  end
end
