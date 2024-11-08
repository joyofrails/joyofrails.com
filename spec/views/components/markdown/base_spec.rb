# frozen_string_literal: true

require "rails_helper"

RSpec.describe Markdown::Base, type: :view do
  it "supports multiple headings" do
    render_component <<~MD
      # 1
      ## 2
      ### 3
      #### 4
      ##### 5
      ###### 6
    MD

    expect(rendered.strip).to be ==
      "<h1>1</h1> <h2>2</h2> <h3>3</h3> <h4>4</h4> <h5>5</h5> <h6>6</h6>"
  end

  it "supports ordered lists" do
    render_component <<~MD
      1. One
      2. Two
      3. Three
    MD

    expect(rendered).to be ==
      "<ol><li>One</li> <li>Two</li> <li>Three</li> </ol>"
  end

  it "supports unordered lists" do
    render_component <<~MD
      - One
      - Two
      - Three
    MD

    expect(rendered).to be ==
      "<ul><li>One</li> <li>Two</li> <li>Three</li> </ul>"
  end

  it "supports inline code" do
    render_component "Some `code` here"
    expect(rendered.strip).to be == "<p>Some <code>code</code> here</p>"
  end

  it "supports block code" do
    render_component <<~MD
      ```ruby
      def foo
        bar
      end
      ```
    MD

    expect(rendered).to be ==
      %(<pre><code class="language-ruby">def foo\n  bar\nend\n</code></pre>)
  end

  it "supports paragraphs" do
    render_component "A\n\nB"
    expect(rendered.strip).to be == "<p>A</p> <p>B</p>"
  end

  it "supports links" do
    render_component "[Hello](world 'title')"
    expect(rendered.strip).to be == %(<p><a href="world" title="title">Hello</a></p>)
  end

  it "supports emphasis" do
    render_component "*Hello*"
    expect(rendered.strip).to be == "<p><em>Hello</em></p>"
  end

  it "supports strong" do
    render_component "**Hello**"
    expect(rendered.strip).to be == "<p><strong>Hello</strong></p>"
  end

  it "supports blockquotes" do
    render_component "> Hello"
    expect(rendered).to be == "<blockquote><p>Hello</p> </blockquote>"
  end

  it "supports horizontal rules" do
    render_component "---"
    expect(rendered).to be == "<hr>"
  end

  it "supports images" do
    render_component "![alt](src 'title')"
    expect(rendered.strip).to be == %(<p><img src="src" alt="alt" title="title"></p>)
  end

  it "supports softbreaks in content as spaces" do
    render_component <<~MD
      One
      Two

      Three
    MD

    expect(rendered.strip).to be == "<p>One Two</p> <p>Three</p>"
  end

  xit "supports blockquote [!NOTE]" do
    render_component <<~MD
      > [!NOTE]
      > Hello!
    MD

    expect(rendered.strip).to match %r{<blockquote><svg .*><p>Hello!</p> </blockquote>}
  end
end
