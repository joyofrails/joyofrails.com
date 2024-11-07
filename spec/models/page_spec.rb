require "rails_helper"

RSpec.describe Page, type: :model do
  it "represents a sitepress resource" do
    page = Page.find_or_create_by!(request_path: "/")

    expect(page.resource).to eq Sitepress.site.get("/")
  end

  describe ".refresh_search_index" do
    it "doesn’t blow up" do
      Page.find_or_create_by!(request_path: "/")

      Page.refresh_search_index
    end
  end

  describe ".search" do
    it "allows searching for pages" do
      page = Page.find_or_create_by!(request_path: "/")

      expect(Page.search("Joy of Rails")).to include page
    end

    it "works after rebuilding index" do
      page = Page.find_or_create_by!(request_path: "/")

      Page.refresh_search_index

      expect(Page.search("Joy of Rails")).to include page
    end
  end

  describe ".rank" do
    it "orders search results by rank" do
      page_1 = Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")
      page_2 = Page.find_or_create_by!(request_path: "/articles/mastering-custom-configuration-in-rails")

      search = Page.search("custom con*")

      expect(search.ranked.to_a).to eq([page_2, page_1])
    end
  end

  describe ".with_snippets" do
    it "orders search results by rank" do
      Page.find_or_create_by!(request_path: "/articles/custom-color-schemes-with-ruby-on-rails")

      page = Page.search("Color*").with_snippets.first

      expect(page.title_snippet).to match(%r{<mark>Color</mark>})
      expect(page.body_snippet).to match(%r{<mark>color</mark>})
    end
  end
end
