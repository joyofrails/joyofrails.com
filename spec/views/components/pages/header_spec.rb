require "rails_helper"

RSpec.describe Pages::Header, type: :view do
  def render(**kwargs, &block)
    described_class.new(**kwargs, &block).call(view_context: view)
  end

  describe "#call" do
    it "renders the title" do
      expect(render(title: "Hello")).to have_css(".page-header h1", text: "Hello")
    end

    it "renders the description" do
      expect(render(description: "Describe me")).to have_css(".page-header p", text: "Describe me")
    end

    it "renders the published date" do
      expect(render(published_on: Date.today)).to have_css("time.dt-published", text: I18n.l(Date.today, format: :pretty))
    end

    it "renders the updated date" do
      expect(render(updated_on: Date.today)).to have_css("time.dt-modified", text: I18n.l(Date.today, format: :pretty))
    end

    it "renders the published and updated date" do
      rendered = render(published_on: Date.yesterday, updated_on: Date.today)
      expect(rendered).to have_css("time.dt-published", text: I18n.l(Date.yesterday, format: :pretty))
      expect(rendered).to have_css("time.dt-modified", text: I18n.l(Date.today, format: :pretty))
    end
  end

  describe Pages::Header::Container do
    def render(**kwargs, &block)
      described_class.new(**kwargs, &block).call(view_context: view)
    end

    it "renders the title block" do
      expect(render { |h| h.title { "Hello" } }).to have_css(".page-header h1", text: "Hello")
    end

    it "renders the description block" do
      expect(render { |h| h.description { "Hello" } }).to have_css(".description", text: "Hello")
    end
  end
end
