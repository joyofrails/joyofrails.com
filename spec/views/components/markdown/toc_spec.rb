require "rails_helper"

RSpec.describe Markdown::Toc, type: :view do
  it "renders nothing for a markdown document without headers" do
    render_component(<<~MD)
      Hello
    MD

    expect(rendered).to eq("")
  end

  it "renders a table of contents from markdown with headers" do
    render_component(<<~MD)
      ## Header 1

      Hello
    MD

    expect(rendered).to eq(<<~HTML.gsub(/\n+/, "").gsub(/>\s+</, "><").gsub(/^\s+/, ""))
      <ul class="toc">
        <li>
          <a href="#header-1" class="header-level-2">Header 1</a>
        </li>
      </ul>
    HTML
  end

  it "renders a table of contents from markdown with nested headers" do
    render_component(<<~MD)
      ## Header 1

      Hello

      ### Header 2

      World

      #### Header 3

      Nested

      ## Header 4

      Un-nested
    MD

    expect(rendered).to eq(<<~HTML.gsub(/\n+/, "").gsub(/>\s+</, "><").gsub(/^\s+/, ""))
      <ul class="toc">
        <li>
          <a href="#header-1" class="header-level-2">Header 1</a>
          <ul>
            <li>
              <a href="#header-2" class="header-level-3">Header 2</a>
            </li>
            <li>
              <a href="#header-3" class="header-level-4">Header 3</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#header-4" class="header-level-2">Header 4</a>
        </li>
      </ul>
    HTML
  end

  def squish_html(html)
    html.gsub(/\n+/, "").gsub(/>\s+</, "><").gsub(/^\s+/, "")
  end
end
