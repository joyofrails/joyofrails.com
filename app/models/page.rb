# frozen_string_literal: true

# ActiveRecord model to represent a static page in the database.
class Page < ApplicationRecord
  include Searchable

  def title
    resource.data.title
  end

  def body
    resource.body
  end

  def body_html
    ApplicationController.render(
      inline: body,
      type: (resource.handler.to_sym == :mdrb) ? :"mdrb-atom" : resource.handler,
      layout: false,
      content_type: "application/atom+xml",
      assigns: {
        format: :atom
      }
    )
  end

  def body_text
    Nokogiri::HTML(body_html).text.squish
  end

  def resource
    Sitepress.site.get(request_path)
  end
end
