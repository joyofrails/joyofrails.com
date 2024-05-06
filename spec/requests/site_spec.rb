require "rails_helper"

RSpec.describe "site: http caching" do
  let(:file_path) { Rails.root.join("app", "content", "pages", "articles", "introducing-joy-of-rails.html.mdrb") }
  let(:file) { File.open(file_path) }

  before do
    allow(Rails.application.config.action_controller).to receive(:perform_caching).and_return(true)
  end

  def stub_sitepress_asset(updated_at:, body:)
    allow_any_instance_of(Sitepress::Asset).to receive(:updated_at).and_return(updated_at)
    allow_any_instance_of(Sitepress::Asset).to receive(:body).and_return(body)
  end

  def stub_file_updated_at(time)
  end

  def do_request(headers: {})
    get "/articles/introducing-joy-of-rails", headers: headers
  end

  def do_request_with_conditional_get_headers
    do_request(headers: {
      "HTTP_IF_NONE_MATCH" => response.headers["ETag"],
      "HTTP_IF_MODIFIED_SINCE" => response.headers["Last-Modified"]
    })
  end

  context "on the first request" do
    it "returns a 200" do
      do_request

      expect(response.status).to eq(200)
    end

    it "sets cache headers" do
      time = Time.now - 1.day
      stub_sitepress_asset(updated_at: time, body: "first request body")

      do_request

      expect(response.headers["ETag"]).to be_present
      expect(response.headers["Last-Modified"]).to eq(time.httpdate)
    end
  end

  context "on a subsequent request" do
    context "if it is not stale" do
      it "returns a 304" do
        time = Time.now - 1.day
        stub_sitepress_asset(updated_at: time, body: "first request body")

        do_request
        do_request_with_conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(time.httpdate)
        expect(response.status).to eq(304)
      end
    end

    context "if it has been updated" do
      it "returns a 200" do
        first_time = Time.now - 1.day
        stub_sitepress_asset(updated_at: first_time, body: "first request body")

        do_request

        second_time = Time.now
        stub_sitepress_asset(updated_at: second_time, body: "second request body")

        do_request_with_conditional_get_headers

        expect(response.headers["ETag"]).to be_present
        expect(response.headers["Last-Modified"]).to eq(second_time.httpdate)
        expect(response.status).to eq(200)
      end
    end
  end
end
