require "rails_helper"

RSpec.describe ClipboardCopy, type: :view do
  def render(text, &block)
    Capybara.string(described_class.new(text:).call)
  end

  it "renders the clipboard copy button" do
    expect(render("Hello")).to have_css("button", text: "Copied!")
  end

  it "gracefully handles text containing ERB when processed by ERB" do
    text = "<%= \"color\" %>"
    rendered = described_class.new(text:).call
    processed = ERB.new(rendered).result(binding)

    expect(Capybara.string(processed)).to have_css("[data-value*=color]")
  end
end
