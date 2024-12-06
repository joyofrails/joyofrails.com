module Pages
  class Timestamp < ApplicationComponent
    include Phlex::Rails::Helpers::TimeTag

    attr_accessor :published_on, :updated_on, :attributes

    def initialize(published_on:, updated_on: nil, **attributes)
      @published_on = published_on
      @updated_on = updated_on
      @attributes = attributes
    end

    def view_template
      if published_on || updated_on
        span(**mix(attributes, class: "block")) do
          if published_on && updated_on
            plain "Published:"
            whitespace
          end
          if published_on
            time_tag published_on, itemprop: "datePublished", class: "dt-published", format: :pretty
          end
          if updated_on
            if published_on
              plain " · "
            end
            plain "Updated:"
            whitespace

            time_tag updated_on, itemprop: "dateModified", class: "dt-modified", format: :pretty
          end
        end
      end
    end
  end
end
