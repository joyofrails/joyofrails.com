class CodeBlock::Footer < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def view_template(&)
    div(class: "code-footer", **@options, &)
  end
end
