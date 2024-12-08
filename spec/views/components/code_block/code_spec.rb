require "rails_helper"

RSpec.describe CodeBlock::Code, type: :view do
  it "renders contents of file" do
    render CodeBlock::Code.new("def ruby = 'awesome'", language: "ruby")
    expect(rendered).to have_content("def ruby = 'awesome'")
    expect(rendered).to have_css("pre code span")
  end

  it "renders contents with line highlights" do
    render CodeBlock::Code.new("def ruby = 'awesome'", language: "ruby", highlight_lines: [1])
    expect(rendered).to have_content("def ruby = 'awesome'")
    expect(rendered).to have_css("pre code div.line-1.hll span")
  end
end
