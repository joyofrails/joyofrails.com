require "rails_helper"

RSpec.describe Markdown::Erb do
  describe ".call" do
    subject { Markdown::Erb.new }
    let(:template) { instance_double(ActionView::Template, type: "") }

    let(:code_block_class) do
      Class.new(Phlex::HTML) do
        def initialize(source, **)
          @source = source
        end

        def view_template
          plain @source
        end
      end
    end

    before do
      stub_const("CodeBlock::Article", code_block_class)
    end

    def render(content, &block)
      Markdown::Erb.new(content).call(&block)
    end

    it "processes text" do
      expect(render("Hello")).to match "Hello"
    end

    it "ignores unfenced erb at start of line" do
      expect(render("<%= 1 + 1 %>")).to eq("<%= 1 + 1 %>")
    end

    it "ignores inline fenced erb following text" do
      expect(render("This is the number <%= 1 + 1 %>")).to eq("<p>This is the number <%= 1 + 1 %></p>")
    end

    it "escapes inline fenced erb" do
      expect(render("`<%= 1 + 1 %>`")).to eq("<p><code>&lt;%= 1 + 1 %&gt;</code></p>")
    end

    it "handles multiline fenced erb" do
      expect(
        render(<<~MD)
          ```
          <%= 1 + 1 %>
          ```
        MD
      ).to eq(%(&lt;%= 1 + 1 %&gt;\n))
    end

    it "handles multiline fenced with multiple erbs" do
      md = <<~MD
        ```
        <%= 1 + 1 %>
        <%= 2 + 2 %>
        ```
      MD
      html = <<~HTML
        &lt;%= 1 + 1 %&gt;
        &lt;%= 2 + 2 %&gt;
      HTML
      expect(render(md)).to eq(html)
    end

    it "handles multiple fences and unfenced areas" do
      md = <<~MD
        <%= 1 + 1 %>
        ```
        <%= 2 + 2 %>
        ```
        <%= 3 + 3 %>
        ```
        <%= 4 + 4 %>
        ```
        <%= 5 + 5 %>
      MD
      html = <<~HTML.strip
        <%= 1 + 1 %>&lt;%= 2 + 2 %&gt;
        <%= 3 + 3 %>&lt;%= 4 + 4 %&gt;
        <%= 5 + 5 %>
      HTML
      expect(render(md)).to eq(html)
    end

    it "renders arbitrary html" do
      md = <<~MD
        <div>Hello</div>
      MD
      html = <<~HTML
        <div>Hello</div>
      HTML
      expect(render(md)).to eq(html)
    end
  end
end
