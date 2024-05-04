# frozen_string_literal: true

require "phlex"
require "markly"

class Markdown::Base < Phlex::HTML
  def initialize(content, flags: Markly::DEFAULT)
    @content = content
    @flags = flags
  end

  def template
    visit(doc)
  end

  private

  def doc
    Markly.parse(@content, flags: @flags)
  end

  def visit(node)
    return if node.nil?

    case node.type
    in :document
      visit_children(node)
    in :softbreak
      whitespace
      visit_children(node)
    in :text
      plain(node.string_content)
    in :header
      case node.header_level
      in 1 then h1 { visit_children(node) }
      in 2 then h2 { visit_children(node) }
      in 3 then h3 { visit_children(node) }
      in 4 then h4 { visit_children(node) }
      in 5 then h5 { visit_children(node) }
      in 6 then h6 { visit_children(node) }
      end
    in :paragraph
      grandparent = node.parent&.parent

      if grandparent&.type == :list && grandparent&.list_tight
        visit_children(node)
      else
        p { visit_children(node) }
      end
    in :link
      a(href: node.url, title: node.title) { visit_children(node) }
    in :image
      img(
        src: node.url,
        alt: node.each.first.string_content,
        title: node.title
      )
    in :emph
      em { visit_children(node) }
    in :strong
      strong { visit_children(node) }
    in :list
      case node.list_type
      in :ordered_list then ol { visit_children(node) }
      in :bullet_list then ul { visit_children(node) }
      end
    in :list_item
      li { visit_children(node) }
    in :code
      inline_code do |**attributes|
        code(**attributes) { plain(node.string_content) }
      end
    in :code_block
      code_block(node.string_content, node.fence_info) do |**attributes|
        pre(**attributes) do
          code(class: "language-#{node.fence_info}") do
            plain(node.string_content)
          end
        end
      end
    in :hrule
      hr
    in :blockquote
      blockquote { visit_children(node) }
    end
  end

  def inline_code(**attributes)
    yield(**attributes)
  end

  def code_block(code, language, **attributes)
    yield(**attributes)
  end

  def visit_children(node)
    node.each { |c| visit(c) }
  end
end
