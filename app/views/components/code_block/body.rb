class CodeBlock::Body < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def view_template(&)
    div(class: "code-body", **@options, &)
  end
end
