# frozen_string_literal: true

require "rails_helper"

RSpec.describe Markdown::Base, type: :view do
  it "supports multiple headings" do
    output = md <<~MD
      # 1
      ## 2
      ### 3
      #### 4
      ##### 5
      ###### 6
    MD

    expect(output.strip).to be ==
      "<h1>1</h1> <h2>2</h2> <h3>3</h3> <h4>4</h4> <h5>5</h5> <h6>6</h6>"
  end

  it "supports ordered lists" do
    output = md <<~MD
      1. One
      2. Two
      3. Three
    MD

    expect(output).to be ==
      "<ol><li>One</li> <li>Two</li> <li>Three</li> </ol>"
  end

  it "supports unordered lists" do
    output = md <<~MD
      - One
      - Two
      - Three
    MD

    expect(output).to be ==
      "<ul><li>One</li> <li>Two</li> <li>Three</li> </ul>"
  end

  it "supports inline code" do
    output = md "Some `code` here"
    expect(output.strip).to be == "<p>Some <code>code</code> here</p>"
  end

  it "supports block code" do
    output = md <<~MD
      ```ruby
      def foo
        bar
      end
      ```
    MD

    expect(output).to be ==
      %(<pre><code class="language-ruby">def foo\n  bar\nend\n</code></pre>)
  end

  it "supports paragraphs" do
    output = md "A\n\nB"
    expect(output.strip).to be == "<p>A</p> <p>B</p>"
  end

  it "supports links" do
    output = md "[Hello](world 'title')"
    expect(output.strip).to be == %(<p><a href="world" title="title">Hello</a></p>)
  end

  it "supports emphasis" do
    output = md "*Hello*"
    expect(output.strip).to be == "<p><em>Hello</em></p>"
  end

  it "supports strong" do
    output = md "**Hello**"
    expect(output.strip).to be == "<p><strong>Hello</strong></p>"
  end

  it "supports blockquotes" do
    output = md "> Hello"
    expect(output).to be == "<blockquote><p>Hello</p> </blockquote>"
  end

  it "supports horizontal rules" do
    output = md "---"
    expect(output).to be == "<hr>"
  end

  it "supports images" do
    output = md "![alt](src 'title')"
    expect(output.strip).to be == %(<p><img src="src" alt="alt" title="title"></p>)
  end

  it "supports softbreaks in content as spaces" do
    output = md <<~MD
      One
      Two

      Three
    MD

    expect(output.strip).to be == "<p>One Two</p> <p>Three</p>"
  end

  xit "supports blockquote [!NOTE]" do
    output = md <<~MD
      > [!NOTE]
      > Hello!
    MD

    expect(output.strip).to match %r{<blockquote><svg .*><p>Hello!</p> </blockquote>}
  end

  def md(content)
    Markdown::Base.new(content).call
  end
end
