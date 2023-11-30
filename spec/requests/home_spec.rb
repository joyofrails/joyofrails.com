require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "renders" do
      get "/"

      expect(response.body).to include("Hello world")
    end
  end
end
