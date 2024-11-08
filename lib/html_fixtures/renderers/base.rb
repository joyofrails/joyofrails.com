module HtmlFixtures
  module Renderers
    class Base
      def fixture_path
        raise NotImplementedError
      end

      def render(view_context)
        raise NotImplementedError
      end
    end
  end
end
