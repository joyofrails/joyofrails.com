class Pages::Header < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::TimeTag

  attr_accessor :current_page

  def initialize(title: nil, description: nil, published_on: nil, updated_on: nil)
    @title = title
    @description = description
    @published_on = published_on
    @updated_on = updated_on
  end

  def view_template
    header(class: "page-header") do
      div(class: "container header-content") do
        if @title_block
          h1(&@title_block)
        else
          h1 { @title }
        end
        p(class: "description") { @description } if @description
        if @published_on || @updated_on
          span(class: "block") do
            if @published_on && @updated_on
              plain "Published:"
              whitespace
            end
            if @published_on
              em do
                time_tag @published_on, itemprop: "datePublished", class: "dt-published"
              end
            end
            if @updated_on
              if @published_on
                plain " // "
              end
              plain "Updated:"
              whitespace

              em do
                time_tag @updated_on, itemprop: "dateModified", class: "dt-modified"
              end
            end
          end
        end
      end
    end
  end

  def title(&block)
    @title_block = block
  end
end
