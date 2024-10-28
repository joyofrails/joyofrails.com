require "rails_helper"

RSpec.describe "Searches", type: :request do
  describe "GET show" do
    it "renders empty without search query" do
      get search_path

      expect(response).to have_http_status(:success)

      expect(page).not_to have_content("No results")
    end

    it "renders No results feedback when query is long enough" do
      get search_path, params: {query: "Pro"}

      expect(response).to have_http_status(:success)

      expect(page).to have_content("No results")
    end

    it "renders the search results without query" do
      Page.create!(request_path: "/pwa-showcase")

      get search_path

      expect(response).to have_http_status(:success)

      expect(page).to have_content("Progressive Web Apps on Rails Showcase")
    end

    it "renders the search results with query" do
      Page.create!(request_path: "/pwa-showcase")
      Page.create!(request_path: "/articles/introducing-joy-of-rails")

      get search_path, params: {query: "Progressive Web Apps"}

      expect(response).to have_http_status(:success)

      expect(page).to have_content("Progressive Web Apps on Rails Showcase")
      expect(page).not_to have_content("Introducing Joy of Rails")
    end
  end
end
