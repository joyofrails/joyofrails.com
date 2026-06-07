module HtmlFixtures
  module Renderers
    class DarkmodeSwitch < Base
      def render(view_context)
        DarkMode::Switch.new.call(
          context: {
            rails_view_context: view_context,
            capture_context: view_context
          }
        )
      end

      def fixture_path
        Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html")
      end
    end
  end
end
