require "rails_helper"

RSpec.describe "Settings Syntax Highlights", type: :request do
  let(:default_syntax_highlight) { Settings::SyntaxHighlight.default }

  def random_syntax_highlight
    (Settings::SyntaxHighlight.all - [default_syntax_highlight]).sample
  end

  describe "GET syntax_highlights#show" do
    it "renders the syntax highlight" do
      get settings_syntax_highlight_path

      expect(response).to have_http_status(:ok)
    end

    it "renders when session syntax highlight is set" do
      patch settings_syntax_highlight_path(settings: {syntax_highlight_name: random_syntax_highlight.name})

      get settings_syntax_highlight_path

      expect(response).to have_http_status(:ok)
    end

    it "renders when preview params are set" do
      get settings_syntax_highlight_path(settings: {syntax_highlight_name: random_syntax_highlight.name})

      expect(response).to have_http_status(:ok)
    end

    it "renders the syntax highlight for css format" do
      get settings_syntax_highlight_path(format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(%r{#{default_syntax_highlight.background_color}}i)
      end
    end

    it "renders for css format when session syntax highlight is set" do
      syntax_highlight = random_syntax_highlight
      patch settings_syntax_highlight_path(settings: {syntax_highlight_name: syntax_highlight.name})

      get settings_syntax_highlight_path(format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(%r{#{syntax_highlight.background_color}}i)
      end
    end

    it "renders for css format when preview params are set" do
      syntax_highlight = random_syntax_highlight
      get settings_syntax_highlight_path(settings: {syntax_highlight_name: syntax_highlight.name}, format: :css)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(%r{#{syntax_highlight.background_color}}i)
      end
    end
  end

  describe "PATCH syntax_highlights#update" do
    let(:syntax_highlight) { random_syntax_highlight }

    it "updates custom syntax highlight" do
      get settings_syntax_highlight_path(format: :css)

      aggregate_failures do
        expect(response.body).not_to match(%r{#{syntax_highlight.background_color}}i)
        expect(response.body).to match(%r{#{default_syntax_highlight.background_color}}i)
      end

      patch settings_syntax_highlight_path(settings: {syntax_highlight_name: syntax_highlight.name})

      expect(response).to have_http_status(:see_other)

      get settings_syntax_highlight_path(format: :css)

      aggregate_failures do
        expect(response.body).to match(%r{#{syntax_highlight.background_color}}i)
        expect(response.body).not_to match(%r{#{default_syntax_highlight.background_color}}i)
      end
    end

    it "deletes custom syntax highlight when set to default" do
      patch settings_syntax_highlight_path(settings: {syntax_highlight_name: syntax_highlight.name})

      get settings_syntax_highlight_path(format: :css)

      expect(response.body).to match(%r{#{syntax_highlight.background_color}}i)

      default_syntax_highlight = Settings::SyntaxHighlight.default

      patch settings_syntax_highlight_path(settings: {syntax_highlight_name: default_syntax_highlight.name})

      get settings_syntax_highlight_path(format: :css)

      aggregate_failures do
        expect(response.body).not_to match(%r{#{syntax_highlight.background_color}}i)
        expect(response.body).to match(%r{#{default_syntax_highlight.background_color}}i)
      end
    end
  end
end
