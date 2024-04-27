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
      stub_const("CodeBlock", code_block_class)
    end

    def render(content, &block)
      view = Markdown::Erb.new(content)
      view.call(view_context: nil, &block)
    end

    it "processes text" do
      expect(render("Hello")).to match "<p>Hello</p>"
    end

    it "ignores unfenced erb" do
      expect(render("<%= 1 + 1 %>")).to eq("<p><%= 1 + 1 %></p>")
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
      html = <<~HTML
        ```
        <%= 1 + 1 %>
        <%= 2 + 2 %>
        ```
      HTML
      processed_html = <<~HTML
        &lt;%= 1 + 1 %&gt;
        &lt;%= 2 + 2 %&gt;
      HTML
      expect(render(html)).to eq(processed_html)
    end

    it "handles multiple fences and unfenced areas" do
      given_html = <<~HTML
        <%= 1 + 1 %>
        ```
        <%= 2 + 2 %>
        ```
        <%= 3 + 3 %>
        ```
        <%= 4 + 4 %>
        ```
        <%= 5 + 5 %>
      HTML
      processed_html = <<~HTML.strip
        <p><%= 1 + 1 %></p>&lt;%= 2 + 2 %&gt;
        <p><%= 3 + 3 %></p>&lt;%= 4 + 4 %&gt;
        <p><%= 5 + 5 %></p>
      HTML
      expect(render(given_html)).to eq(processed_html)
    end
  end
end
