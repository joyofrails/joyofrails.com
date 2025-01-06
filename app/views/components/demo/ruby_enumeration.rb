module Demo
  class RubyEnumeration < ApplicationComponent
    attr_reader :demo_type

    def initialize(demo_type = "default")
      @demo_type = demo_type.to_s
    end

    def view_template
      iframe(
        id: [:ruby, :enumeration, demo_type].join("-"),
        data: {
          "controller" => "demo-ruby-enumeration",
          "demo-ruby-enumeration-url-value" => iframe_src,
          "action" => "darkmode:announce@window->demo-ruby-enumeration#darkmode"
        },
        loading: "lazy",
        width: "100%",
        height: focused_demo_type? ? "785px" : "845px"
      )
    end

    def base_uri
      if demo_running_locally?
        Addressable::URI.parse("http://localhost:5173/ruby-enumeration-demo/")
      else
        Addressable::URI.parse("https://joyofrails.github.io/ruby-enumeration-demo/")
      end
    end

    FOCUSED_DEMO_TYPES = %w[eager lazy].freeze
    def iframe_src
      uri = base_uri
      uri.query_values = {demoType: demo_type}
      uri.to_s
    end

    def focused_demo_type? = FOCUSED_DEMO_TYPES.include?(demo_type)

    def demo_running_locally? = ENV["JOY_OF_RAILS_LOCAL_DEMO_RUBY_ENUMERATION"] == "true"
  end
end
