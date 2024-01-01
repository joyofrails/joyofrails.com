require "rails_helper"

RSpec.describe "www", type: :request do
  before(:each) do
    host! "www.example.com"
  end

  it "redirects www to root domain" do
    get "/"

    expect(response.status).to eq(301)
    expect(response.headers["Location"]).to eq("http://example.com/")
  end
end
