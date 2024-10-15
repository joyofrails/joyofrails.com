class Errors::UnprocessableView < ApplicationView
  def view_template
    render Pages::Header::Container.new do |header|
      header.title { "422 UNPROCESSABLE" }
      header.description { "Oops! The change you wanted was rejected 😱" }
    end

    render Errors::ErrorBody do
      p { "I just can‘t process this. Darn, sorry that happened. Let‘s not get down." }
      p { "Look on the bright side. I‘m sure you‘re still a good person." }

      render Errors::SpotifyEmbed.new(src: "https://open.spotify.com/embed/track/0gFpdYnovoEx9JGGsibsmD?utm_source=generator")
    end
  end
end
