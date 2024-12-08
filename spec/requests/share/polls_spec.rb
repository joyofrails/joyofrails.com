require "rails_helper"

RSpec.describe "/polls", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      FactoryBot.create(:poll, author: FactoryBot.create(:user))
      get share_polls_url
      expect(response).to be_successful
    end

    it "does not render the New Poll button when not allowed" do
      get share_polls_url

      expect(document).not_to have_content("New Poll")
    end

    it "renders the New Poll button when allowed" do
      Flipper.enable(:polls, login_as_user)
      get share_polls_url

      expect(document).to have_content("New Poll")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      poll = FactoryBot.create(:poll, author: FactoryBot.create(:user))
      get share_poll_url(poll)
      expect(response).to be_successful
    end
  end
end
