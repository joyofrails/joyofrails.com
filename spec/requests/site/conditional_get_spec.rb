require "rails_helper"

RSpec.describe "Site: http caching" do
  let(:file_path) { Rails.root.join("app", "content", "pages", "articles", "introducing-joy-of-rails.html.mdrb") }
  let(:file) { File.open(file_path) }

  before do
    allow(Rails.application.config.action_controller).to receive(:perform_caching).and_return(true)
  end

  def stub_sitepress_asset(body:, updated_at: nil)
    allow_any_instance_of(Sitepress::Asset).to receive(:updated_at).and_return(updated_at) if updated_at
    allow_any_instance_of(Sitepress::Asset).to receive(:body).and_return(body)
  end

  def conditional_get_headers
    {
      "HTTP_IF_NONE_MATCH" => response.headers["ETag"],
      "HTTP_IF_MODIFIED_SINCE" => response.headers["Last-Modified"]
    }
  end

  context "on the first request" do
    it "returns a 200" do
      get "/articles/introducing-joy-of-rails"

      expect(response.status).to eq(200)
    end

    it "sets cache headers for sitepress asset" do
      time = Time.now - 1.day
      stub_sitepress_asset(updated_at: time, body: "first request body")

      get "/articles/introducing-joy-of-rails"

      expect(response.headers["ETag"]).to be_present
      expect(response.headers["Last-Modified"]).to eq(time.httpdate)
    end

    it "sets cache headers from Page record" do
      time = Time.now - 1.day

      Page.upsert_page_by_request_path!("/articles/introducing-joy-of-rails", upserted_at: time)

      get "/articles/introducing-joy-of-rails"

      expect(response.headers["ETag"]).to be_present
      expect(response.headers["Last-Modified"]).to eq(time.httpdate)
    end
  end

  context "on a subsequent request" do
    context "if it is not stale" do
      it "returns a 304 for timestamp from Sitepress asset" do
        time = Time.now - 1.day
        stub_sitepress_asset(updated_at: time, body: "first request body")

        get "/articles/introducing-joy-of-rails"
        get "/articles/introducing-joy-of-rails", headers: conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(time.httpdate)
        expect(response.status).to eq(304)
      end

      it "returns a 304 for timestamp from Page record" do
        time = Time.now - 1.day

        Page.upsert_page_by_request_path!("/articles/introducing-joy-of-rails", upserted_at: time)

        get "/articles/introducing-joy-of-rails"
        get "/articles/introducing-joy-of-rails", headers: conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(time.httpdate)
        expect(response.status).to eq(304)
      end
    end

    context "if it has been updated" do
      it "returns a 200 with timestamp from Sitepress asset" do
        first_time = Time.now - 1.day
        stub_sitepress_asset(updated_at: first_time, body: "first request body")

        get "/articles/introducing-joy-of-rails"

        second_time = Time.now
        stub_sitepress_asset(updated_at: second_time, body: "second request body")

        get "/articles/introducing-joy-of-rails", headers: conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(second_time.httpdate)
        expect(response.status).to eq(200)
      end

      it "returns a 200 with timestamp from Page record" do
        first_time = Time.now - 1.day
        Page.upsert_page_by_request_path!("/articles/introducing-joy-of-rails", upserted_at: first_time)
        stub_sitepress_asset(body: "first request body")

        get "/articles/introducing-joy-of-rails"

        second_time = Time.now
        Page.upsert_page_by_request_path!("/articles/introducing-joy-of-rails", upserted_at: second_time)
        stub_sitepress_asset(body: "second request body")

        get "/articles/introducing-joy-of-rails", headers: conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(second_time.httpdate)
        expect(response.status).to eq(200)
      end
    end
  end
end
