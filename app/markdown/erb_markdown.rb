# DANGER! This parses Erb, which means arbitrary Ruby can be run. Make sure
# you trust the source of your markdown and that its not user input.

class ErbMarkdown < ApplicationMarkdown
  # Enables Erb to render for the entire doc before the markdown is rendered.
  # This works great, except when you have an `erb` code fence.
  def preprocess(html)
    # Read more about this render call at https://guides.rubyonrails.org/layouts_and_rendering.html
    unescape_erb render(inline: escape_erb(html), handler: :erb)
  end

  def unescape_erb(html)
    html.gsub("%%", "%")
  end

  # Converts ERB tags inside code fences to `%%` to avoid processing ERB inside code fences.
  #
  # Solution adapted from:
  # https://stackoverflow.com/questions/65028292/using-regex-to-find-multiple-matches-between-two-strings
  #
  # Imagine a string like this:
  #
  #   c x c x A c x c x c B c x c x
  #
  # Find any "c" character that is between "A" and "B". So in this example I need to get 3 matches.
  #
  # Given A and B are different single character strings, use negated character classes:
  #
  # (?:\G(?!^)|A)[^AB]*?\Kc(?=[^AB]*B)
  # See this regex demo. Details:
  #
  # * (?:\G(?!^)|A) - A or end of the previous successful match
  # * [^AB]*? - any zero or more chars other than A and B, as few as possible
  # * \K - match reset operator that discards all text matched so far in the overall memory match buffer
  # * c - a c char/string
  # * (?=[^AB]*B) - that must be followed with zero or more chars other than A and B and then B char immediately to the right of the current location.
  #
  def escape_erb(html)
    html
      .gsub(/(?:\G(?!^)|`)(.*?)\K<%(?=.*`)/m, "\\2<%%\\3")
      .gsub(/(?:\G(?!^)|`)(.*?)\K%>(?=.*`)/m, "\\2%%>\\3")
  end
end
