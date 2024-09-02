# frozen_string_literal: true

class Users::NewsletterSubscriptions::Banner < ApplicationComponent
  include Phlex::Rails::Helpers::TurboFrameTag

  def view_template(&block)
    div(class: "newsletter-banner section-content container py-gap mb-3xl lg:py-3xl lg:grid-cols-1/2") do
      h3(class: "font-semibold") do
        plain "The Joy of Rails Newsletter: "
        span { "A spark of joy for your inbox" }
      end

      div do
        p(class: "mb-4") do
          "I'll notify you when I post new content about Ruby on Rails. Positive vibes only."
        end
        div(&block)
      end
    end
  end
end
