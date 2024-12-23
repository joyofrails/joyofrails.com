module Demo
  class RubyEnumeration < ApplicationComponent
    include Phlex::Rails::Helpers::TurboFrameTag

    attr_reader :query

    def initialize(**query)
      @query = query
    end

    def view_template
      turbo_frame_tag [:ruby, :enumeration, demo_type], class: "ruby-enumeration-demo" do
        iframe(
          src: iframe_src,
          height: focused_demo_type? ? "635px" : "695px",
          loading: "lazy",
          width: "100%"
        )
      end
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
      uri.query_values = (uri.query_values || {}).merge(query).transform_keys { |k| k.to_s.camelize(:lower) }
      uri.to_s
    end

    def demo_type = query.fetch(:demo_type, "default")

    def focused_demo_type? = FOCUSED_DEMO_TYPES.include?(demo_type)

    def demo_running_locally? = true
  end
end
