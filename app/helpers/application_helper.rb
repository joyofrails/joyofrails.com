module ApplicationHelper
  def seo_meta_tags
    set_meta_tags icon: [
      {rel: "icon", href: "/favicon.ico?v1.0", sizes: "32x32"},
      {rel: "icon", href: "/icon.svg?v1.0", type: "image/svg+xml"},
      {rel: "apple-touch-icon", href: "/apple-touch-icon.png?v1.0"}
    ]
    set_meta_tags index: true
    set_meta_tags icon: "/favicon.ico"
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
