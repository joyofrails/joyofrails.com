require "rails_helper"

RSpec.describe Atom::EntryContent do
  subject { ArticlePage.published.first } # introducing_joy_of_rails.mdrb

  describe "#render" do
    it "renders the article body as html without enhanced markdown" do
      html = described_class.new(subject).render
      expect(html).to include("<h2>How it started, How it’s going</h2>")
      expect(html).to include(%(<div class="code-wrapper highlight language-ruby"><pre><code><span class="k">class</span>))
    end

    it "rewrites turbo frame content" do
      html = described_class.new(subject).render
      expect(html).not_to include("<turbo-frame")
      expect(html).to include("<a href=\"/articles/introducing-joy-of-rails\">Click here to see demo</a>")
    end
  end
end
