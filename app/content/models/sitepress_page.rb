class SitepressPage < Sitepress::Model
  collection glob: "**/*.html*"
  data :title

  def self.render_html(resource, format: :atom)
    type = (format == :atom && resource.handler.to_sym == :mdrb) ? :"mdrb-atom" : resource.handler
    content_type = (format == :atom) ? "application/atom+xml" : "text/html"

    ApplicationController.render(
      inline: resource.body,
      type:,
      content_type:,
      layout: false,
      assigns: {format:}
    )
  end
end
