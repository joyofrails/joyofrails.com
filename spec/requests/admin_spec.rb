require "rails_helper"

RSpec.describe "Admin", type: :request do
  describe "GET admin" do
    context "when signed in as admin user" do
      before { login_admin_user }

      it "renders flipper-ui" do
        get "/admin/flipper/features"

        expect(response.status).to eq(200)
      end
    end

    context "when signed out" do
      it "does not render flipper ui" do
        get "/admin/flipper"

        expect(response.status).to eq(404)
      end

      it "does not render jobs" do
        get "/admin/jobs"

        expect(response.status).to eq(404)
      end
    end
  end
end
