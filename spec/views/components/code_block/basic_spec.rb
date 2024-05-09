require "rails_helper"

RSpec.describe CodeBlock::Basic, type: :view do
  def render_page(*, **)
    Capybara.string(render(*, **))
  end

  it "renders contents of file" do
    page = render_page(CodeBlock::Basic.new("def ruby = 'awesome'", language: "ruby"))
    expect(page).to have_content("def ruby = 'awesome'")
  end
end
