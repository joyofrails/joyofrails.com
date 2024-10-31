require "rails_helper"

RSpec.describe Page, type: :model do
  it "represents a sitepress resource" do
    page = Page.find_or_create_by!(request_path: "/")

    expect(page.resource).to eq Sitepress.site.get("/")
  end

  describe ".rebuild_search_index" do
    it "doesn’t blow up" do
      Page.find_or_create_by!(request_path: "/")

      Page.rebuild_search_index
    end
  end

  describe ".search" do
    it "allows searching for pages" do
      page = Page.find_or_create_by!(request_path: "/")

      expect(Page.search("Joy of Rails")).to include page
    end

    it "works after rebuilding index" do
      page = Page.find_or_create_by!(request_path: "/")

      Page.rebuild_search_index

      expect(Page.search("Joy of Rails")).to include page
    end
  end
end
