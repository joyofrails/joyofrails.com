require "rails_helper"

RSpec.describe "PWA resources", type: :request do
  describe "GET /manifest.json" do
    it "returns the PWA manifest" do
      get "/manifest.json"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to match(%r{application/manifest\+json})

      manifest = JSON.parse(response.body, symbolize_names: true)
      expect(manifest[:theme_color]).to match(/^#[0-9a-f]{6}$/)
      expect(manifest[:background_color]).to match(/^#[0-9a-f]{6}$/)
    end

    it "ignores other formats" do
      get "/manifest.js"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /serviceworker.js" do
    it "returns the PWA service worker" do
      get "/serviceworker.js"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to match("text/javascript")
    end

    it "ignores other formats" do
      get "/serviceworker.json"
      expect(response).to have_http_status(:not_found)
    end
  end
end
