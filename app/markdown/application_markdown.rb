# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  # Reformats your boring punctation like " and " into “ and ” so you can look
  # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  include Redcarpet::Render::SmartyPants

  # If you need access to ActionController::Base.helpers, you can delegate by uncommenting
  # and adding to the list below. Several are already included for you in the `MarkdownRails::Renderer::Rails`,
  # but you can add more here.
  #
  # delegate \
  #   :request,
  #   :cache,
  #   :turbo_frame_tag,
  # to: :helpers

  FORMATTER = Rouge::Formatters::HTML.new

  def enable
    [:fenced_code_blocks]
  end

  def block_code(code, language)
    lexer = Rouge::Lexer.find(language)
    content_tag :pre, class: "highlight language-#{language}" do
      content_tag :code do
        raw FORMATTER.format(lexer.lex(code))
      end
    end
  end

  # Example of how you might override the images to show embeds, like a YouTube video.
  def image(link, title, alt)
    url = URI(link)
    case url.host
    when "www.youtube.com"
      youtube_tag url, alt
    else
      super
    end
  end

  private

  # This is provided as an example; there's many more YouTube URLs that this wouldn't catch.
  def youtube_tag(url, alt)
    embed_url = "https://www.youtube-nocookie.com/embed/#{CGI.parse(url.query).fetch("v").first}"
    content_tag :iframe,
      src: embed_url,
      width: 560,
      height: 325,
      allow: "encrypted-media; picture-in-picture",
      allowfullscreen: true \
        do alt end
  end
end
