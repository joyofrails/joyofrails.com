require "rails_helper"

RSpec.describe "Feed", type: :request do
  describe "GET /feed" do
    it "renders" do
      get "/feed"

      expect(response.status).to eq(200)
      page = Capybara.string(response.body)

      expect(page).to have_content("Introducing Joy of Rails")
      expect(page).to have_content("/introducing-joy-of-rails")
      expect(page).to have_content("How it started, How it’s going</h2>")
      expect(page).to have_content("<pre><code data-code-example-target=\"source\">")
    end
  end
end
