require "rails_helper"

RSpec.describe "Errors", type: :request do
  describe "GET /404" do
    it "returns a 404 status code" do
      get "/404"
      expect(response.body).to include("404 NOT FOUND")
      expect(response).to have_http_status(404)
    end
  end

  describe "GET /422" do
    it "returns a 422 status code" do
      get "/422"
      expect(response.body).to include("422 UNPROCESSABLE")
      expect(response).to have_http_status(422)
    end
  end

  describe "GET /500" do
    it "returns a 500 status code" do
      get "/500"
      expect(response.body).to include("500 INTERNAL SERVER ERROR")
      expect(response).to have_http_status(500)
    end
  end
end
