# DANGER! This parses Erb, which means arbitrary Ruby can be run. Make sure
# you trust the source of your markdown and that its not user input.

class Markdown::Erb < Markdown::Application
  class Handler
    class << self
      def call(template, content)
        content = Markdown::Erb.new(content, flags: Markly::UNSAFE).call
        erb.call(template, content)
      end

      def erb
        @erb ||= ActionView::Template.registered_template_handler(:erb)
      end
    end
  end

  ERB_TAGS = %r{s*<%.*?%>}

  def visit(node)
    return if node.nil?

    case node.type
    in :paragraph
      # Markly will parse ERB tags as text nodes inside a paragraph; we don't want to nest
      # generated HTML inside a paragraph by default, so we need to handle this case separately.
      first_child = node.first
      if first_child&.type == :text && first_child.string_content.match?(ERB_TAGS)
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
end
