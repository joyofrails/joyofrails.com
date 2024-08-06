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
      let(:color_schemes) do
        FactoryBot.build_list(:color_scheme, 3)
      end

      before do
        allow(ColorScheme).to receive(:curated).and_return(color_schemes)
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

    it "renders color scheme as css" do
      color_scheme = FactoryBot.create(:color_scheme)

      get color_scheme_path(color_scheme, format: :css)

      expect(response).to have_http_status(:ok)

      validator = W3CValidators::CSSValidator.new
      validator_results = validator.validate_text(response.body) # W3CValidators::Results

      expect(validator_results.is_valid?).to be(true), "Expected CSS to be valid, but got: #{validator_results.errors.map(&:to_s).join(", ")}"
    end
  end
end
