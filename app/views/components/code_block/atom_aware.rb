# Prepend this module to the CodeBlock::Component class to render the basic code block when rendering within an Atom feed.
module CodeBlock::AtomAware
  def view_template
    # When a code block renders within an Atom feed, we want to render the basic code block
    if content_type?("application/atom+xml")
      render ::CodeBlock::Container.new(language: language) do
        render ::CodeBlock::Code.new(source, language: language)
      end
    else
      super
    end
  end

  def content_type?(type)
    helpers&.headers&.[]("Content-Type").to_s =~ %r{#{Regexp.escape(type)}}
  end
end
