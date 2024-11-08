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

    def self.ensure_inline_svg_id_consistency!
      require_relative "patches/inline_svg_id_generator_randomness_override"
    end
  end
end
