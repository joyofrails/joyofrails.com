# frozen_string_literal: true

class Users::ThankYous::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  def view_template
    article do
      render Pages::Header.new(
        title: "Welcome to Joy of Rails!",
        description: "Thank you for signing up 😂"
      )

      div(class: "section-content container py-gap mb-3xl") do
        p { "Here's what you can do next:" }
        ul(class: "list-disc list-outside px-4") do
          li do
            plain "Check your your email for a confirmation link to activate your account."
            whitespace
            plain "If you don’t see it, check your spam folder, or you can"
            whitespace
            link_to("resend the confirmation email", new_users_confirmation_path)
            plain "."
          end
          li do
            plain "Check out"
            whitespace
            strong { link_to("articles", "/articles") }
            whitespace
            plain "I’ve written on Ruby, Rails, and Hotwire."
            if ArticlePage.published.length < 5
              whitespace
              plain "I’m working on adding some new content, so check back soon!"
            end
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
