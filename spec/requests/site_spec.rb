require "rails_helper"

RSpec.describe "site: http caching" do
  let(:file_path) { Rails.root.join("app", "content", "pages", "articles", "introducing-joy-of-rails.html.mdrb") }
  let(:file) { File.open(file_path) }

  def do_request
    get "/articles/introducing-joy-of-rails"
  end

  def do_request_and_set_request_conditional_get_headers
    do_request

    request.env["HTTP_IF_NONE_MATCH"] = response.headers["ETag"]
    request.env["HTTP_IF_MODIFIED_SINCE"] = response.headers["Last-Modified"]

    do_request
  end

  context "on the first request" do
    it "returns a 200" do
      do_request

      expect(response.status).to eq(200)
    end

    it "sets cache headers" do
      do_request

      expect(response.headers["ETag"]).to be_present
      expect(response.headers["Last-Modified"]).to be_present
    end
  end

  context "on a subsequent request" do
    context "if it is not stale" do
      it "returns a 304" do
        do_request_and_set_request_conditional_get_headers
        do_request

        expect(response.status).to eq(304)
      end
    end

    context "if it has been updated" do
      it "returns a 200" do
        do_request_and_set_request_conditional_get_headers
        do_request

        expect(response.status).to eq(200)
      end
    end
  end
end
