module Rails
  module HTML4
    class Sanitizer
      def sanitize(html, ...) = html

      def sanitize_css(style) = style

      def self.full_sanitizer = self
    end
  end
end
