module Pages
  class List < ApplicationComponent
    attr_reader :pages
    def initialize(pages)
      @pages = pages
    end

    def view_template
      div(class: "card-list mt-16 grid grid-cols-1 grid-gap lg:grid-cols-3") do
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
