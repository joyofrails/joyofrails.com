# DANGER! This parses Erb, which means arbitrary Ruby can be run. Make sure
# you trust the source of your markdown and that its not user input.

module Markdown::AllowsErb
  ERB_TAGS = %r{s*<%.*?%>}
  ERB_TAGS_START = %r{\A<%.*?%>}

  def visit(node)
    return if node.nil?

    case node.type
    in :paragraph
      # Commonmarker will parse ERB tags as text nodes inside a paragraph. When
      # the text starts with ERB, we don't want to nest generated HTML inside a
      # paragraph by default, so we need to handle this case separately.
      first_child = node.first
      if first_child&.type == :text && first_child.string_content.match?(ERB_TAGS_START)
        visit_children(node)
      else
        super
      end
    in :text
      if node.string_content.match?(ERB_TAGS)
        unsafe_raw(node.string_content)
      else
        super
      end
    else
      super
    end
  end

  class Handler
    def initialize(component_class)
      @component_class = component_class
    end

    def call(template, content)
      content = @component_class.new(content).call(view_context:)
      erb.call(template, content)
    end

    private

    def view_context
      ApplicationController.new.view_context
    end

    def erb
      @erb ||= ActionView::Template.registered_template_handler(:erb)
    end
  end
end
