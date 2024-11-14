module Pages
  class Summary < ApplicationComponent
    include Phlex::Rails::Helpers::TimeTag
    include Phlex::Rails::Helpers::ImageTag

    def self.from_page(page, **)
      new(
        title: page.title,
        request_path: page.request_path,
        description: page.description,
        published_on: page.published_on,
        image: page.image,
        **
      )
    end

    def initialize(title: nil, description: nil, published_on: nil, image: nil, request_path: nil, side: "right")
      @title = title
      @description = description
      @published_on = published_on
      @image = image
      @request_path = request_path
      @side = side
    end

    def view_template
      div(class: "page-summary grid grid-gap lg:grid-cols-2 lg:grid-flow-col") do
        case @side
        when "left"
          content(class: "grid grid-row-tight lg:text-right lg:grid-column-start-1")
          image(class: "grid grid-row-tight lg:text-left lg:grid-column-start-2")
        else
          content(class: "grid grid-row-tight lg:text-left lg:grid-column-start-2")
          image(class: "grid grid-row-tight lg:text-right lg:grid-column-start-1")
        end
      end
    end

    def content(**)
      div(**) do
        a(href: @request_path) do
          h2(class: "important") { @title }
        end
        p(class: "description") { @description } if @description
        if @published_on
          span(class: "block") do
            # <time datetime="2024-03-13T00:00:00Z" itemprop="datePublished" class="dt-published"> March 13th, 2024 </time>
            time_tag @published_on, itemprop: "datePublished", class: "dt-published"
          end
        end
        a(href: @request_path, class: "block uppercase strong") do
          small { "Read now" }
        end
      end
    end

    def image(**)
      div(**) do
        figure(class: "page-summary--image") do
          image_tag @image, class: "w-full object-cover aspect-[2/1] lg:aspect-[3/2]"
        end
      rescue
        ActionView::Template::Error
      end
    end
  end
end
