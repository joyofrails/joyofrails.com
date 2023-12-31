require "rails_helper"

RSpec.describe "Admin", type: :request do
  before(:each) do
    host! "example.com"
  end

  describe "GET admin" do
    context "when feature enabled" do
      before { Flipper.enable(:admin_access) }

      it "renders liteboard" do
        get "/liteboard"

        expect(response.status).to eq(200)
      end

      it "renders flipper-ui" do
        get "/flipper/features"

        expect(response.status).to eq(200)
      end
    end

    context "when feature enabled" do
      before { Flipper.disable(:admin_access) }

      it "does not render liteboard" do
        get "/liteboard"

        expect(response.status).to eq(404)
      end

      it "does not render flipper ui" do
        get "/flipper"

        expect(response.status).to eq(404)
      end
    end
  end
end
