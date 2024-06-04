require "rails_helper"

RSpec.describe Atom::EntryContent do
  let(:article) { ArticlePage.published.first } # introducing_joy_of_rails.mdrb

  describe "#render" do
    it "renders the article body as html without enhanced markdown" do
      html = described_class.new(article).render
      expect(html).to include("<h2>How it started, How it’s going</h2>")
      expect(html).to include(%(<div class="code-wrapper highlight language-ruby"><pre><code><span class="k">class</span>))
    end

    it "rewrites turbo frame content" do
      html = described_class.new(article).render
      expect(html).not_to include("<turbo-frame")
      expect(html).to include("<a href=\"/articles/introducing-joy-of-rails\">Click here to see content</a>")
    end

    it "replaces relative urls with absolute urls" do
      request = instance_double(ActionDispatch::Request, base_url: "http://example.com")
      html = described_class.new(article, request: request).render

      doc = Nokogiri::HTML.fragment(html)

      expect(doc.css("img").any? { |img| img["src"].start_with?("/") }).to be(false), "Expected all images to be absolute urls but found: #{doc.css("img").select { |img| img["src"].start_with?("/") }}"
      expect(doc.css("img").any? { |img| img["src"].start_with?("http://example.com/assets") }).to be(true), "Expected some images to have the base url prepended but found none"

      expect(doc.css("a").any? { |a| a["href"].start_with?("/") }).to be(false), "Expected all link to be absolute urls but found: #{doc.css("a").select { |a| a["href"].start_with?("/") }}"
      expect(doc.css("a").any? { |a| a["href"].start_with?("http://example.com") }).to be(true), "Expected some links to have the base url prepended but found none"
    end
  end
end
