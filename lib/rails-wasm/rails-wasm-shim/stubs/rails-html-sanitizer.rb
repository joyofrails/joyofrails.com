module Rails
  module HTML
    class Sanitizer
      def sanitize(html, ...) = html

      def sanitize_css(style) = style

      def self.full_sanitizer = self

      def self.best_supported_vendor = Rails::HTML4::Sanitizer
    end
  end

  module HTML4
    class Sanitizer
      def sanitize(html, ...) = html

      def sanitize_css(style) = style

      def self.full_sanitizer = self
    end
  end
end
