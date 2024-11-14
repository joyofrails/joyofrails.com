module Pages
  class Info < ApplicationComponent
    attr_reader :title, :description, :request_path
    def initialize(title:, description:, request_path:, **)
      @title = title
      @description = description
      @request_path = request_path
    end

    def view_template
      a(
        href: request_path,
        data: {
          turbo_frame: "_top"
        },
        class: ["pb-2", "block"]
      ) do
        div(class: "font-semibold") { title }
        div(class: "text-sm") { description }
      end
    end
  end
end
