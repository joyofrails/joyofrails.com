require "rails_helper"

RSpec.xdescribe "Users::Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/users/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/users/sessions/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/users/sessions/destroy"
      expect(response).to have_http_status(:success)
    end
  end
end
