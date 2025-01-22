# index.xml.builder
xml.instruct!
xml.sitemapindex xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.sitemap do
    xml.loc sitemap_pages_url(format: :xml)
    xml.lastmod Time.utc(2020, 12, 21, 11).strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
end
