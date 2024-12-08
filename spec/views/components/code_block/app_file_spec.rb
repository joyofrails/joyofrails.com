require "rails_helper"

RSpec.describe CodeBlock::AppFile, type: :view do
  before do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end

  it "renders contents of file" do
    render(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb"))
    expect(rendered).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
        def add(m, n)
          m + n
        end
      end
    RUBY
    expect(rendered).to have_content("spec/fixtures/code_block/app_file/example.rb")
  end

  it "renders contents of file by line number" do
    render(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: 2))
    expect(rendered).to have_content(<<~RUBY.strip)
      def add(m, n)
    RUBY

    expect(rendered).not_to have_content("class FixturesCodeBlockAppFileExample")
  end

  it "renders contents of file by line number range" do
    render(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: [2..4]))

    expect(rendered).to have_content("def add(m, n)\n    m + n\n  end")
    expect(rendered).not_to have_content("class FixturesCodeBlockAppFileExample")
  end

  it "renders contents of file by heterogeneous line number collection" do
    render(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb", lines: [1, 3..5]))
    expect(rendered).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
          m + n
        end
      end
    RUBY
  end

  it "renders basic code block when content type is atom" do
    allow(view).to receive(:headers).and_return({"Content-Type" => "application/atom+xml"})

    render(CodeBlock::AppFile.new("spec/fixtures/code_block/app_file/example.rb"))
    expect(rendered).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
        def add(m, n)
          m + n
        end
      end
    RUBY

    expect(rendered).not_to have_content("spec/fixtures/code_block/app_file/example.rb")
  end
end
