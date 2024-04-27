# Markdown::Toc == Markdown::TableOfContents
class Markdown::Toc < Markdown::Base
  def view_template
    @tree = []
    visit(doc)

    if @tree.any?
      ul(class: "toc") do
        @tree.each do |header, sub_headers|
          li do
            header_link(header)
            if sub_headers.any?
              ul do
                sub_headers.each do |sub_header|
                  li do
                    header_link(sub_header)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def visit(node)
    return if node.nil?

    case node.type

    # collect header nodes in a 2-level hierarchy
    in :header
      if @tree.empty? || node.header_level <= 2
        @tree << [node, []]
      elsif node.header_level > 2
        @tree.last[1] << node
      end
    else
      visit_children(node)
    end
  end

  def visit_children(node)
    node.each { |c| visit(c) }
  end

  def header_link(node)
    content = capture do
      node.each do |child|
        plain child.string_content
      end
    end
    a(href: "##{content.parameterize}", class: "header-level-#{node.header_level}") do
      plain content
    end
  end
end
