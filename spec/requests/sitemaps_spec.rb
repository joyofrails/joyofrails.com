require "rails_helper"

RSpec.describe "Sitemaps", type: :request do
  describe "GET /sitemaps" do
    it "renders list of sitemaps" do
      get sitemaps_path(format: :xml)

      expect(response).to have_http_status(200)
      expect(document).to have_xpath("//sitemapindex/sitemap/loc", text: "http://example.com/sitemap-pages.xml")
    end
  end

  describe "GET /sitemap-pages.xml" do
    it "renders sitemap" do
      pages = Page.upsert_collection_from_sitepress!(limit: 3)
      pages.each.with_index do |page, i|
        page.update(published_at: (i + 1).days.ago)
      end

      get sitemap_pages_path(format: :xml)

      expect(response).to have_http_status(200)
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/")
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/about")
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/articles")
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/contact")
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/meta")
      expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com/settings")

      pages.each do |page|
        expect(document).to have_xpath("//urlset/url/loc", text: "http://example.com#{page.request_path}")
      end
    end
  end
end
