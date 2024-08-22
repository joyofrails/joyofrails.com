require "rails_helper"

RSpec.describe CodeBlock::AppFileRun, type: :view do
  def render_page(*, **)
    Capybara.string(render(*, **))
  end

  before do
    allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
  end

  it "renders contents of file" do
    page = render_page(CodeBlock::AppFileRun.new("spec/fixtures/code_block/app_file/example.rb"))
    expect(page).to have_content(<<~RUBY.strip)
      class FixturesCodeBlockAppFileExample
        def add(m, n)
          m + n
        end
      end
    RUBY
    expect(page).to have_content("spec/fixtures/code_block/app_file/example.rb")
  end
end
