module SyntaxHighlights
  class CssColor
    attr_reader :background_color, :path

    # Calculate the perceived brightness of the color, according to Github Copilot
    def self.brightness(r:, g:, b:)
      (0.299 * r + 0.587 * b + 0.114 * b) / 255
    end

    def initialize(path)
      @path = path

      parse!
    end

    def parse!
      parser = CssParser::Parser.new
      parser.load_file!(path)

      rule = parser.find_rule_sets([".highlight"]).each(&:expand_background_shorthand!).map { |d| d["background-color"] }.reject(&:blank?).first
      rule = rule&.gsub(/[\s;].*$/, "") # remove extra parts, e.g. ";, !important;"

      @background_color = ColorConversion::Color.new(rule)
    rescue ColorConversion::InvalidColorError => e
      puts "Error parsing #{path}: #{e.message}"
    end

    def brightness
      @brightness ||= self.class.brightness(**background_color.rgb)
    end

    # Calculate the perceived brightness of the color
    def light?
      brightness > 0.5
    end

    def dark?
      !light?
    end
  end
end

namespace :syntax_highlights do
  desc "Categorize syntax highlights as light or dark"
  task :seed do
    require "css_parser"
    require "color_conversion"

    syntax_data = Dir[Rails.root.join("app", "assets", "stylesheets", "pygments", "*.css")].sort.map do |path|
      name = File.basename(path, ".css")
      css_color = SyntaxHighlights::CssColor.new(path)

      {
        name: name,
        title: name.titleize,
        background_color: css_color.background_color.hex,
        mode: css_color.light? ? "light" : "dark"
      }
    end

    File.write("config/syntax_highlights.yml", syntax_data.to_yaml)
  end
end
