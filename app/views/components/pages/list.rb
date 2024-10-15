module Pages
  class List < ApplicationComponent
    attr_reader :pages, :attributes
    def initialize(pages, **attributes)
      @pages = pages
      @attributes = attributes
    end

    def view_template
      div(**mix(attributes, class: "card-list grid grid-cols-1 grid-gap lg:grid-cols-3")) do
        pages.each do |page|
          render Pages::Card.new(
            title: page.title,
            request_path: page.request_path,
            description: page.description,
            image: page.image
          )
        end
      end
    end
  end
end
