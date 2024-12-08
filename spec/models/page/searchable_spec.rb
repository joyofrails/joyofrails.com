require "rails_helper"

RSpec.describe Page::Searchable, type: :model do
  describe ".search" do
    it "allows searching for pages" do
      page = FactoryBot.create(:page, :published, request_path: "/")
      page.update_in_search_index

      expect(Page.search("Joy of Rails")).to include page
    end

    it "works after rebuilding index" do
      page = FactoryBot.create(:page, :published, request_path: "/")
      page.update_in_search_index

      Page.find_each(&:update_in_search_index)

      expect(Page.search("Joy of Rails")).to include page
    end
  end

  describe ".rank" do
    it "orders search results by rank" do
      page_1 = FactoryBot.create(:page, :published, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")
      page_2 = FactoryBot.create(:page, :published, request_path: "/articles/mastering-custom-configuration-in-rails")
      page_1.update_in_search_index
      page_2.update_in_search_index

      search = Page.search("custom con*")

      expect(search.ranked.to_a).to eq([page_2, page_1])
    end
  end

  describe ".with_snippets" do
    it "orders search results by rank" do
      page = FactoryBot.create(:page, :published, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")
      page.update_in_search_index

      page = Page.search("Color*").with_snippets.first

      expect(page.title_snippet).to match(%r{<mark>Color</mark>})
      expect(page.body_snippet).to match(%r{<mark>color</mark>})
    end
  end
end
