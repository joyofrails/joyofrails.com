require "rails_helper"

RSpec.describe Markdown::Atom, type: :view do
  let(:template) { instance_double(ActionView::Template, type: "") }

  it "processes text" do
    expect(render_component("Hello")).to match "Hello"
  end

  it "ignores unfenced erb at start of line" do
    expect(render_component("<%= 1 + 1 %>")).to eq("<%= 1 + 1 %>")
  end

  it "renders basic code block" do
    md = <<~MD
      ```
      1 + 1
      ```
    MD
    html = <<~HTML
      <pre><code>1 + 1</code></pre>
    HTML
    expect(render_component(md).delete("\n")).to eq(html.delete("\n"))
  end

  it "renders arbitrary html" do
    md = <<~MD
      <div>Hello</div>
    MD
    html = <<~HTML
      <div>Hello</div>
    HTML
    expect(render_component(md)).to eq(html)
  end
end
