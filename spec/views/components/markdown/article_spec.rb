require "rails_helper"

RSpec.describe Markdown::Article, type: :view do
  describe ".call" do
    before do
      allow(view).to receive(:headers).and_return({"Content-Type" => "text/html"})
    end

    def render(content, &block)
      described_class.new(content).call(view_context: view, &block)
    end

    it "processes text" do
      expect(render("Hello")).to match "Hello"
    end

    it "ignores unfenced erb at start of line" do
      expect(render("<%= 1 + 1 %>")).to eq("<%= 1 + 1 %>")
    end

    it "renders article code block" do
      md = <<~MD
        ```
        1 + 1
        ```
      MD

      page = Capybara.string(render(md))
      code = page.find("pre code")

      expect(code).to have_content("1 + 1")
      expect(page).to have_content("Copied")
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

    it "renders basic code block when content type is atom" do
      allow(view).to receive(:headers).and_return({"Content-Type" => "application/atom+xml"})

      md = <<~MD
        ```
        1 + 1
        ```
      MD

      page = Capybara.string(render(md))
      code = page.find("pre code")

      expect(code).to have_content("1 + 1")
      expect(page).not_to have_content("Copied!")
    end
  end
end
