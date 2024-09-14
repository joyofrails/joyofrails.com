class Errors::NotFoundView < ApplicationView
  def view_template
    render Pages::Header.new do |header|
      header.title { "404 NOT FOUND" }
      header.description { "Oops! The page you were looking for doesn’t exist 🧐" }
    end

    render Errors::ErrorBody do
      p { "That‘s right, the page you were looking for does not exist." }
      p do
        plain "Unless you"
        whitespace
        em { "were" }
        whitespace
        plain "looking for the 404 page, in which case: Congrats! You found it!"
      end
      p do
        "But it‘s still a 404 Not Found in either case, which might be confusing if you were looking for the 404 page on purpose."
      end
      p { "So... did you find what you were looking for?" }

      render Errors::SpotifyEmbed.new(src: "https://open.spotify.com/embed/track/3MRQ3CSjoiV1HFil8ykM9M?utm_source=generator")
    end
  end
end
