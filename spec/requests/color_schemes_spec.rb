require "rails_helper"

RSpec.describe "Color Schemes" do
  describe "GET /color_schemes" do
    context "no color schemes exist" do
      it "renders color schemes with expected content" do
        get "/color_schemes"

        expect(response).to have_http_status(:ok)
      end
    end

    context "color schemes exist" do
      before do
        FactoryBot.create_list(:color_scheme, 3)
      end

      it "renders color schemes with expected content" do
        get color_schemes_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /color_schemes/:id" do
    it "renders color scheme with expected content" do
      color_scheme = FactoryBot.create(:color_scheme)

      get color_scheme_path(color_scheme)

      expect(response).to have_http_status(:ok)
    end
  end
end
