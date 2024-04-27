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

  ERB_TAGS_START = %r{s*<%.*?%>}

  def visit(node)
    return if node.nil?

    case node.type
    in :text
      if node.string_content.match?(ERB_TAGS_START)
        unsafe_raw(node.string_content)
      else
        super
      end
    else
      super
    end
  end
end
