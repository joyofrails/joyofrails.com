module Pages
  class Header < ApplicationComponent
    attr_accessor :current_page, :title, :description, :published_on, :updated_on

    def initialize(title: nil, description: nil, published_on: nil, updated_on: nil)
      @title = title
      @description = description
      @published_on = published_on
      @updated_on = updated_on
    end

    def view_template(&)
      render Container.new do |c|
        c.title { title }
        c.description { description } if description
        div do
          render Pages::Timestamp.new published_on: published_on, updated_on: updated_on
        end
      end
    end

    class Container < ApplicationComponent
      def view_template(&)
        header(class: "page-header") do
          div(class: "container header-content", &)
        end
      end

      def title(**attributes, &)
        h1(**mix(attributes, class: "mb-4"), &)
      end

      def description(**attributes, &)
        p(**mix(attributes, class: "description"), &)
      end

      def actions(&)
        div(class: "actions", &) if block_given?
      end
    end
  end
end
