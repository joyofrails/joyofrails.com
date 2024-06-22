class PageHeader < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::TimeTag

  attr_accessor :current_page

  def initialize(title: nil, description: nil, published_on: nil)
    @title = title
    @description = description
    @published_on = published_on
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
        if @published_on
          span(class: "block") do
            # <time datetime="2024-03-13T00:00:00Z" itemprop="datePublished" class="dt-published"> March 13th, 2024 </time>
            time_tag @published_on, itemprop: "datePublished", class: "dt-published"
          end
        end
      end
    end
  end

  def title(&block)
    @title_block = block
  end
end
