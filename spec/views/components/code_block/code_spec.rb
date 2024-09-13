require "rails_helper"

RSpec.describe CodeBlock::Code, type: :view do
  def render_page(*, **)
    Capybara.string(render(*, **))
  end

  it "renders contents of file" do
    page = render_page(CodeBlock::Code.new("def ruby = 'awesome'", language: "ruby"))
    expect(page).to have_content("def ruby = 'awesome'")
    expect(page).to have_css("pre code span")
  end

  it "renders contents with line highlights" do
    page = render_page(CodeBlock::Code.new("def ruby = 'awesome'", language: "ruby", highlight_lines: [1]))
    expect(page).to have_content("def ruby = 'awesome'")
    expect(page).to have_css("pre code div.line-1.hll span")
  end
end
