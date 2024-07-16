require "rails_helper"

RSpec.describe PlausibleClient, vcr: true do
  subject(:client) { described_class.new }

  describe "#post_event" do
    it "posts an event to Plausible" do
      response = client.post_event(
        name: "test event",
        url: "http://joyofrails.com/about",
        headers: {
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 OPR/71.0.3770.284",
          "X-Forwarded-For" => "127.0.0.1"
        }
      )

      expect(response.code.to_i).to eq(202)
    end
  end
end
