class MarkdownToc < Phlex::HTML
  def initialize(content)
    @content = content
    @curr = nil
    @prev = nil
  end

  def view_template
    ul(class: "toc") {
      visit(doc)
    }

    # case node.header_level
    #   in 1 then h1 { visit_children(node) }
    #   in 2 then h2 { visit_children(node) }
    #   in 3 then h3 { visit_children(node) }
    #   in 4 then h4 { visit_children(node) }
    #   in 5 then h5 { visit_children(node) }
    #   in 6 then h6 { visit_children(node) }
    # end
  end

  def header(node, &)
    content = capture(&)
    li do
      a(href: "##{content.parameterize}", class: "header-level-#{node.header_level}") do
        content
      end
    end
  end

  def doc
    Markly.parse(@content)
  end

  def visit(node)
    return if node.nil?

    case node.type
    in :header
      header(node) { visit_header_children(node) }
    else
      visit_children(node)
    end
  end

  def visit_header_children(node)
    node.each do |c|
      plain(c.string_content)
    end
  end

  def visit_children(node)
    node.each { |c| visit(c) }
  end
end
