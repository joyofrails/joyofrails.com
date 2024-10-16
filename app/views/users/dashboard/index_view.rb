# frozen_string_literal: true

class Users::Dashboard::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  def view_template
    article do
      render Pages::Header.new(
        title: "Welcome to Joy of Rails!",
        description: "Thank you for signing up 😂"
      )

      div(class: "article-content container mb-3xl") do
        p { "Here's what you can do next:" }
        ul(class: "list-disc list-outside px-4") do
          li do
            plain "Check out"
            whitespace
            strong { link_to("articles", "/articles") }
            whitespace
            plain "I’ve written on Ruby, Rails, and Hotwire."
          end
          li do
            plain "If you’re interested in learning how this app is built or even contributing to it, check out the"
            whitespace
            link_to("source code", "https://github.com/joyofrails/joyofrails")
            whitespace
            plain "on GitHub."
          end
          li do
            plain "Connect with me on"
            whitespace
            link_to("Twitter", "https://twitter.com/rossta", target: "_blank")
            plain ","
            whitespace
            link_to("Mastodon", "https://ruby.social/rossta", target: "_blank")
            whitespace
            plain ", and"
            whitespace
            link_to("LinkedIn", "https://www.linkedin.com/in/rosskaffenberger", target: "_blank")
            whitespace
          end
        end
      end
    end
  end
end
