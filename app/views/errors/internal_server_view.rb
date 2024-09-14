class Errors::InternalServerView < ApplicationView
  def view_template
    render Pages::Header.new do |header|
      header.title { "500 INTERNAL SERVER ERROR" }
      header.description { "Oops! Something went wrong 😭" }
    end

    render Errors::ErrorBody do
      p { "Well, this is embarassing." }
      p { "It‘s not you, it’s me." }
      p { "Something went wrong on my end and I will try to do something to fix it. At some point. Like, not right away." }
      p do
        plain "But, seriously, if you think you found a bug, feel free to"
        whitespace
        a(href: "https://github.com/joyofrails/joyofrails.com/issues/new?assignees=&labels=&projects=&template=bug_report.md&title=") do
          "report it on the Joy of Rails GitHub repository"
        end
        plain "."
      end

      render Errors::SpotifyEmbed.new(src: "https://open.spotify.com/embed/track/0rUIff1QHd5zlOBtlHVqd9?utm_source=generator")
    end
  end
end
