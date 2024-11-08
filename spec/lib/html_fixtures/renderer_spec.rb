require "rails_helper"

RSpec.describe HtmlFixtures::Renderer do
  it "renders all fixtures" do
    HtmlFixtures::Renderer.new.render_all

    expect(File.exist?(Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html"))).to be true
    expect(File.exist?(Rails.root.join("app", "javascript", "test", "fixtures", "views", "searches", "combobox.html"))).to be true
  end
end
