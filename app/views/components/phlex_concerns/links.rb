module PhlexConcerns::Links
  def link(url, title = "", **attrs, &)
    extra_attrs = {}

    unless url.blank? || url.start_with?("/", "#")
      extra_attrs[:target] ||= "_blank"
      extra_attrs[:rel] ||= "noopener noreferrer"
    end

    a(href: url, title: title, **extra_attrs, **attrs, &)
  end
end
