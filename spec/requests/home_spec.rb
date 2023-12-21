require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "renders" do
      get "/"

      within("main") do
        expect(response.body).to include("Joy of Rails")
      end

      within(".newsletter-banner") do
        expect(response.body).to include("A spark of joy for your inbox")
      end
    end
  end
end
