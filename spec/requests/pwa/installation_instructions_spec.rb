require "rails_helper"

RSpec.describe "/pwa/installation_instructions", type: :request do
  describe "GET /pwa/installation_instructions" do
    it "succeeds" do
      get "/pwa/installation_instructions"

      expect(response).to have_http_status(:success)
    end
  end
end
