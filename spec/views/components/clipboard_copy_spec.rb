require "rails_helper"

RSpec.describe ClipboardCopy, type: :view do
  it "renders the clipboard copy button" do
    render_component(text: "Hello")

    expect(rendered).to have_css("button", text: "Copied!")
  end

  it "gracefully handles text containing ERB when processed by ERB" do
    render_component(text: "<%= \"color\" %>")

    processed = ERB.new(rendered).result(binding)

    expect(processed).to have_css("[data-value*=color]")
  end
end
