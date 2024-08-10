require "rails_helper"

RSpec.describe "/newsletters", type: :request do
  describe "GET /" do
    it "renders a successful response" do
      FactoryBot.create_list(:newsletter, 2)

      get newsletters_path

      expect(response).to be_successful
    end

    it "renders a successful without newsletters" do
      get newsletters_path

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      newsletter = FactoryBot.create(:newsletter)

      get newsletter_path(newsletter)

      expect(response).to be_successful
    end
  end
end
