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
      header(node.header_level) { visit_children(node) }
      whitespace
    in :paragraph
      grandparent = node.parent&.parent

      if grandparent&.type == :list && grandparent&.list_tight
        visit_children(node)
      else
        p { visit_children(node) }
        whitespace
      end
    in :link
      link(node.url, node.title) { visit_children(node) }
    in :image
      image(node.url, alt: node.each.first.string_content, title: node.title)
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
      whitespace
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
    in :table
      table { visit_children(node) }
    in :table_row
      tr { visit_children(node) }
    in :table_cell
      td { visit_children(node) }
    in :html_block
      html_block(node.to_html(options: @options))
    in :html_inline
      html_inline(node.to_html(options: @options))
    in :strikethrough
      s { visit_children(node) }
    in :escaped
      visit_children(node)
    end
  end

  def header(header_level, &)
    send(:"h#{header_level}", &)
  end

  def image(src, alt: "", title: "")
    img(src: src, alt: alt, title: title)
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

  def html_block(html)
    # We skip rendering of arbitrary HTML here in safe mode
  end

  def html_inline(html)
    # We skip rendering of arbitrary HTML here in safe mode
  end

  private

  def visit_children(node)
    node.each { |c| visit(c) }
  end
end
