namespace :fixtures do
  task html: :environment do
    if Rails.env.local?
      class InlineSvg::IdGenerator::Randomness
        class << self
          prepend InlineSvgIdGeneratorRandomnessOverrideForFixtures
        end
      end
    end

    Rake::Task["db:seed"].invoke

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

    File.write(
      Rails.root.join("app", "javascript", "test", "fixtures", "views", "searches", "combobox.html"),
      Searches::Combobox.new(pages: Page.search("Rails*").with_snippets.ranked.limit(3), query: "Rails").call(view_context:)
    )
  end
end

module InlineSvgIdGeneratorRandomnessOverrideForFixtures
  def call
    "non-random-for-fixtures"
  end
end
