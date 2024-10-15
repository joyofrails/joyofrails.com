module Pages
  class Card < ApplicationComponent
    include Phlex::Rails::Helpers::ImageTag

    attr_reader :title, :description, :image, :request_path
    def initialize(title:, description:, image:, request_path:)
      @title = title
      @image = image
      @description = description
      @request_path = request_path
    end

    def view_template
      article(class: "") do
        a(href: request_path, class: "block") do
          figure(class: "page-card--image w-full") do
            image_tag @image,
              alt: description,
              class: "aspect-[16/9] w-full rounded-2xl object-cover sm:aspect-[2/1] lg:aspect-[3/2]"
          end
        end
        div(class: "max-w-xl") do
          h3(
            class:
              "mt-3 mb-2 text-lg font-semibold leading-6"
          ) do
            a(href: request_path) do
              span(class: "title inset-0")
              plain title
            end
          end
          p(class: "description line-clamp-3 text-sm leading-6 text-gray-600") do
            description
          end
        end
      end
    end
  end
end

# Tag
# div(class: "mt-8 flex items-center gap-x-4 text-xs") do
#   a(
#     href: "#",
#     class:
#       "relative z-10 rounded-full bg-gray-50 px-3 py-1.5 font-medium text-gray-600 hover:bg-gray-100"
#   ) { "Marketing" }
# end
