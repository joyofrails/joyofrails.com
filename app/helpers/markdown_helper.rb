module MarkdownHelper
  def basic_markdown(text)
    render Markdown::Base.new(text)
  end
end
