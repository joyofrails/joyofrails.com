module HtmlFixtures
  class Renderer
    def render_all
      [
        HtmlFixtures::Renderers::DarkmodeSwitch.new,
        HtmlFixtures::Renderers::SearchesCombobox.new
      ].each do |renderer|
        File.write(renderer.fixture_path, renderer.render(view_context))
      end
    end

    def view_context
      @view_context ||= build_view_context
    end

    def build_view_context
      request = ActionDispatch::Request.new({})
      request.routes = ApplicationController._routes

      instance = ApplicationController.new
      instance.set_request! request
      instance.set_response! ApplicationController.make_response!(request)
      instance.view_context
    end
  end
end

# We need to override the randomness of the InlineSvg gem to ensure that the SVG
# IDs are consistent across test runs and git commits.
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
