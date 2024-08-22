class CodeBlock::Container < ApplicationComponent
  include Phlex::Rails::Helpers::ClassNames

  attr_reader :language, :classes, :options

  def initialize(language: "plain", **options)
    @language = language
    @classes = options.delete(:class)
    @options = options
  end

  def view_template(&)
    div(
      class: class_names("code-wrapper", "highlight", "language-#{language}", *classes),
      **options,
      &
    )
  end
end
