module ApplicationHelper
  def seo_meta_tags
    favicon_path = Rails.env.local? ? asset_path("app-icons/favicon-local.ico") : asset_path("app-icons/favicon.ico")
    set_meta_tags icon: [
      {rel: "icon", href: favicon_path, sizes: "32x32"},
      {rel: "icon", href: asset_path("app-icons/icon.svg"), type: "image/svg+xml"},
      {rel: "apple-touch-icon", href: asset_path("app-icons/apple-touch-icon.png")}
    ]
    set_meta_tags index: true
    set_meta_tags og: {
      title: :title,
      description: :description,
      type: "article",
      url: url_for,
      site_name: Rails.configuration.x.application_name,
      locale: "en_US"
    }
    set_meta_tags twitter: {
      site: "@joyofrails"
    }
    display_meta_tags site: Rails.configuration.x.application_name
  end
end
