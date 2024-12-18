module Demo
  class RubyEnumeration < ApplicationComponent
    attr_reader :demo_type
    def initialize(demo_type: "combined")
      @demo_type = demo_type.to_s
    end

    def view_template
      iframe(
        src: iframe_src,
        height: focused_demo_type? ? "635px" : "695px",
        loading: "lazy",
        width: "100%"
      )
    end

    def base_uri
      Addressable::URI.parse("https://joyofrails.github.io/ruby-enumeration-demo/")
    end

    FOCUSED_DEMO_TYPES = %w[eager lazy].freeze
    def iframe_src
      uri = base_uri
      if focused_demo_type?
        uri.query_values = (uri.query_values || {}).merge(demoType: demo_type)
      end
      uri.to_s
    end

    def focused_demo_type? = FOCUSED_DEMO_TYPES.include?(demo_type)
  end
end
