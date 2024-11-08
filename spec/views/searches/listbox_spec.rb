require "rails_helper"

RSpec.describe Searches::Listbox, type: :view do
  let(:search_result) do
    Data.define(:title, :url, :body) do
      def to_key = [url.parameterize]

      def model_name = ActiveModel::Name.new(self, nil, "SearchResult")
    end
  end

  let(:search_result_component) do
    Class.new(ApplicationComponent) do
      attr_reader :search_result

      def initialize(search_result)
        @search_result = search_result
      end

      def view_template
        a(href: search_result.url) do
          div { raw safe(search_result.title) }
          div { raw safe(search_result.body) }
        end
      end
    end
  end

  it "renders search results" do
    Searches::Result.register(search_result, search_result_component)

    search_results = [
      search_result.new(title: "Joy of Rails", url: "/articles/joy-of-rails", body: "Rails is a web application framework"),
      search_result.new(title: "Love of Ruby", url: "/articles/love-of-ruby", body: "Ruby is a programming language")
    ]

    render_component(results: search_results)

    expect(rendered).to have_content("Joy of Rails")
    expect(rendered).to have_css(%([href="/articles/joy-of-rails"]))
    expect(rendered).to have_content("Love of Ruby")
    expect(rendered).to have_css(%([href="/articles/love-of-ruby"]))
  end

  it "raises an error when no component is registered for the result" do
    search_results = [
      search_result.new(title: "Joy of Rails", url: "/articles/joy-of-rails", body: "Rails is a web application framework"),
      search_result.new(title: "Love of Ruby", url: "/articles/love-of-ruby", body: "Ruby is a programming language")
    ]

    expect {
      render_component(results: search_results)
    }.to raise_error(ArgumentError, %r{\[Searches::Result\] No component registered})
  end
end
