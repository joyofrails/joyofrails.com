require "rails_helper"

RSpec.describe "Settings Color Schemes", type: :request do
  let(:default_color_scheme) { ColorScheme.find_or_create_default }
  let(:curated_colors) do
    FactoryBot.create_list(:color_scheme, 3)
  end

  before do
    default_color_scheme

    allow(ColorScheme).to receive(:curated).and_return(curated_colors)
  end

  describe "GET color_schemes#show" do
    it "renders the color scheme" do
      get settings_color_scheme_path

      expect(response).to have_http_status(:ok)
    end

    it "renders when session color scheme is set" do
      patch settings_color_scheme_path(settings: {color_scheme_id: FactoryBot.create(:color_scheme).id})

      get settings_color_scheme_path

      expect(response).to have_http_status(:ok)
    end

    it "renders when preview params are set" do
      get settings_color_scheme_path(settings: {color_scheme_id: FactoryBot.create(:color_scheme).id})

      expect(response).to have_http_status(:ok)
    end

    it "renders the color scheme for css format" do
      get settings_color_scheme_path(format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match("--color-#{default_color_scheme.name.parameterize}")
      end
    end

    it "renders for css format when session color scheme is set" do
      color_scheme = FactoryBot.create(:color_scheme)
      patch settings_color_scheme_path(settings: {color_scheme_id: color_scheme.id})

      get settings_color_scheme_path(format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match("--color-#{color_scheme.name.parameterize}")
      end
    end

    it "renders for css format when preview params are set" do
      color_scheme = FactoryBot.create(:color_scheme)
      get settings_color_scheme_path(settings: {color_scheme_id: color_scheme.id}, format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match("--color-#{color_scheme.name.parameterize}")
      end
    end
  end

  describe "PATCH color_schemes#update" do
    let(:color_scheme) { FactoryBot.create(:color_scheme) }

    it "updates custom color scheme" do
      get settings_color_scheme_path(format: :css)

      aggregate_failures do
        expect(response.body).not_to match("--color-#{color_scheme.name.parameterize}")
        expect(response.body).to match("--color-#{default_color_scheme.name.parameterize}")
      end

      patch settings_color_scheme_path(settings: {color_scheme_id: color_scheme.id})

      expect(response).to have_http_status(:see_other)

      get settings_color_scheme_path(format: :css)

      aggregate_failures do
        expect(response.body).to match("--color-#{color_scheme.name.parameterize}")
        expect(response.body).not_to match("--color-#{default_color_scheme.name.parameterize}")
      end
    end

    it "deletes custom color scheme when set to default" do
      patch settings_color_scheme_path(settings: {color_scheme_id: color_scheme.id})

      get settings_color_scheme_path(format: :css)

      expect(response.body).to match("--color-#{color_scheme.name.parameterize}")

      default_color_scheme = ColorScheme.find_or_create_default

      patch settings_color_scheme_path(settings: {color_scheme_id: default_color_scheme.id})

      get settings_color_scheme_path(format: :css)

      aggregate_failures do
        expect(response.body).not_to match("--color-#{color_scheme.name.parameterize}")
        expect(response.body).to match("--color-#{default_color_scheme.name.parameterize}")
      end
    end

    it "sends a plausible event" do
      plausible_request = stub_request(:post, "https://plausible.io/api/event")

      patch settings_color_scheme_path(settings: {color_scheme_id: color_scheme.id})

      perform_enqueued_jobs

      expect(plausible_request).to have_been_requested
    end
  end
end
