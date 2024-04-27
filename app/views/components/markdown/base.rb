class Markdown::Base < Phlex::Markdown
  def initialize(content, flags: Markly::DEFAULT)
    super(content)
    @flags = flags
  end

  attr_reader :flags

  def doc
    Markly.parse(@content, flags: @flags)
  end
end
