# frozen_string_literal: true

require "phlex"
require "commonmarker"

class Markdown::Base < Phlex::HTML
  def initialize(content, **options)
    @content = content
    @options = default_commonmarker_options.merge(options)
  end

  def view_template
    visit(doc)
  end

  protected

  def doc
    Commonmarker.parse(@content, options: @options)
  end

  # Options for CommonMarker
  def default_commonmarker_options
    {}
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
    in :heading
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
      link(node.url, node.title) { visit_children(node) }
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
      in :ordered then ol { visit_children(node) }
      in :bullet then ul { visit_children(node) }
      end
    in :item
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
    in :thematic_break
      hr
    in :block_quote
      blockquote { visit_children(node) }
    in :html_block
      # This is a raw HTML block, so we skip here in safe mode
    end
  end

  def inline_code(**attributes)
    yield(**attributes)
  end

  def code_block(code, language, **attributes)
    yield(**attributes)
  end

  def link(url, title, **attrs, &)
    a(href: url, title: title, &)
  end

  private

  def visit_children(node)
    node.each { |c| visit(c) }
  end
end
