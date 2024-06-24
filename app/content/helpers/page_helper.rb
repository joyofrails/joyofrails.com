# frozen_string_literal: true

module PageHelper
  DEFAULT_TITLE_KEY = "title"

  # Creates a hyperlink to a page using the `title` key. Change the default in the args
  # below if you use a different key for page titles.
  def link_to_page(page, *, title_key: DEFAULT_TITLE_KEY, **, &block)
    if block
      link_to(page.request_path, *, **, &block)
    else
      link_to(page.data[DEFAULT_TITLE_KEY], page.request_path, *, **)
    end
  end

  # Quick and easy way to change the class of a page if its current. Useful for
  # navigation menus.
  def link_to_if_current(text, page, active_class: "active")
    if page == current_page
      link_to text, page.request_path, class: active_class
    else
      link_to text, page.request_path
    end
  end

  # Render a block within a layout. This is a useful, and prefered way, to handle
  # nesting layouts, within Sitepress.
  def render_layout(layout, **, &)
    render(html: capture(&), layout: "layouts/#{layout}", **)
  end

  def render_toc(page)
    render Markdown::Toc.new(page.asset.body)
  end

  def link_to_app_file(path, text = nil, *, **, &)
    app_file = Examples::AppFile.from(path)
    link_to(*[text, app_file.repo_url].compact, **, &)
  end
end
