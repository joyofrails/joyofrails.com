module ApplicationHelper
  def seo_meta_tags
    set_meta_tags icon: [
      {rel: "icon", href: asset_path("app-icons/favicon.ico"), sizes: "32x32"},
      {rel: "icon", href: asset_path("app-icons/icon.svg"), type: "image/svg+xml"},
      {rel: "apple-touch-icon", href: asset_path("app-icons/apple-touch-icon.png")}
    ]
    set_meta_tags index: true
    set_meta_tags og: {
      title: :title,
      description: :description,
      type: "article",
      url: url_for,
      site_name: "Joy of Rails",
      locale: "en_US"
    }
    set_meta_tags twitter: {
      site: "@joyofrails"
    }
    display_meta_tags site: "Joy of Rails"
  end
end
