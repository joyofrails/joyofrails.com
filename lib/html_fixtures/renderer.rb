module HtmlFixtures
  class Renderer
    def render_all
      request = ActionDispatch::Request.new({})
      request.routes = ApplicationController._routes

      instance = ApplicationController.new
      instance.set_request! request
      instance.set_response! ApplicationController.make_response!(request)
      view_context = instance.view_context

      File.write(
        Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html"),
        DarkMode::Switch.call
      )

      search_result = Data.define(:title, :url, :body) do
        def to_key = [url.parameterize]

        def model_name = ActiveModel::Name.new(self, nil, "SearchResult")
      end

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

        Searches::Result.register(search_result, self)
      end

      search_results = [
        search_result.new(title: "Here’the thing", url: "/articles/heres-the-thing", body: "Ruby is a programming language"),
        search_result.new(title: "Introducing Joy of Rails", url: "/articles/joy-of-rails", body: "Rails is a web application framework")
      ]

      File.write(
        Rails.root.join("app", "javascript", "test", "fixtures", "views", "searches", "combobox.html"),
        Searches::Combobox.new(results: search_results, query: "Rails").call(view_context:)
      )
    end
  end
end

module InlineSvgIdGeneratorRandomnessOverrideForFixtures
  def call
    "non-random-for-fixtures"
  end
end

if Rails.env.local?
  class InlineSvg::IdGenerator::Randomness
    class << self
      prepend InlineSvgIdGeneratorRandomnessOverrideForFixtures
    end
  end
end
