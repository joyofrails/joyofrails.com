class Pages::Header < ApplicationComponent
  attr_accessor :current_page, :title, :description, :published_on, :updated_on

  def initialize(title: nil, description: nil, published_on: nil, updated_on: nil)
    @title = title
    @description = description
    @published_on = published_on
    @updated_on = updated_on
  end

  def view_template
    render Container.new do |c|
      c.title { title }
      c.description { description } if description
      render Timestamp.new published_on: published_on, updated_on: updated_on
    end
  end

  class Container < ApplicationComponent
    def view_template(&)
      header(class: "page-header") do
        div(class: "container header-content", &)
      end
    end

    def title(&)
      h1(&)
    end

    def description(&)
      p(class: "description", &)
    end
  end

  class Timestamp < ApplicationComponent
    include Phlex::Rails::Helpers::TimeTag

    attr_accessor :published_on, :updated_on
    def initialize(published_on:, updated_on:)
      @published_on = published_on
      @updated_on = updated_on
    end

    def view_template
      if published_on || updated_on
        span(class: "block") do
          if published_on && updated_on
            plain "Published:"
            whitespace
          end
          if published_on
            em do
              time_tag published_on, itemprop: "datePublished", class: "dt-published"
            end
          end
          if updated_on
            if published_on
              plain " // "
            end
            plain "Updated:"
            whitespace

            em do
              time_tag updated_on, itemprop: "dateModified", class: "dt-modified"
            end
          end
        end
      end
    end
  end
end
