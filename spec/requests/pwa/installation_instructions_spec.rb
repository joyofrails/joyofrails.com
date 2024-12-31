require "rails_helper"
require "faker"

RSpec.describe "/pwa/installation_instructions", type: :request do
  describe "GET /pwa/installation_instructions" do
    it "succeeds with user agent" do
      get "/pwa/installation_instructions", params: {}, headers: {"HTTP_USER_AGENT" => Faker::Internet.user_agent}

      expect(response).to have_http_status(:success)
    end

    it "succeeds when user agent not detected" do
      get "/pwa/installation_instructions", params: {}, headers: {}

      expect(response).to have_http_status(:success)
    end

    user_agent_glob = Dir[Rails.root.join("app", "views", "pwa", "installation_instructions", "user_agents", "*.html.erb")]
    user_agent_partials = user_agent_glob.map do |path|
      File.basename(path, ".html.erb").sub(/^_/, "")
    end

    user_agent_partials.each do |partial_name|
      it "succeeds for user_agent_nickname #{partial_name.inspect}" do
        get "/pwa/installation_instructions", params: {user_agent_nickname: partial_name}

        expect(response).to have_http_status(:success)
      end
    end

    it "is not found otherwise" do
      get "/pwa/installation_instructions/sprinkles_and_rainbows"

      expect(response).to have_http_status(:not_found)
    end
  end
end
