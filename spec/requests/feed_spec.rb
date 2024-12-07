require "rails_helper"

RSpec.describe "Feed", type: :request do
  let(:curated_colors) do
    FactoryBot.create_list(:color_scheme, 3)
  end

  before do
    allow(ColorScheme).to receive(:curated).and_return(curated_colors)
  end

  describe "GET /feed" do
    it "renders feed with expected content" do
      Page.upsert_collection_from_sitepress!

      get "/feed"

      expect(response.status).to eq(200)
      page = Capybara.string(response.body)

      expect(page).to have_content("Introducing Joy of Rails")
      expect(page).to have_content("/introducing-joy-of-rails")
      expect(page).to have_content("How it started, How it’s going</h2>")
      expect(page).to have_content(%(<div class="code-wrapper highlight language-ruby"><pre><code><span class="k">class</span>))
      expect(page).not_to have_content(%(<turbo-frame))
    end

    it "render valid feed" do
      Page.upsert_collection_from_sitepress!

      get "/feed"

      validator = W3CValidators::FeedValidator.new
      validator_results = validator.validate_text(response.body) # W3CValidators::Results

      expect(validator_results.is_valid?).to be(true), "Expected feed to be valid, but got: #{validator_results.errors.map(&:to_s).join(", ")}"
    end

    it "doesn’t break if an article gets moved" do
      Page.upsert_collection_from_sitepress!

      Page.published.first.update!(request_path: "/articles/new-path")

      expect { get "/feed" }.not_to raise_error
    end
  end
end
