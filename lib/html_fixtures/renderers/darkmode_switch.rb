module HtmlFixtures
  module Renderers
    class DarkmodeSwitch < Base
      def render(view_context)
        DarkMode::Switch.new.call(view_context:)
      end

      def fixture_path
        Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html")
      end
    end
  end
end
