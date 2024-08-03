module ApplicationHelper
  def seo_meta_tags
    set_meta_tags icon: [
      {rel: "icon", href: "/favicon.ico?v1.0", sizes: "32x32"},
      {rel: "icon", href: "/icon.svg?v1.0", type: "image/svg+xml"},
      {rel: "apple-touch-icon", href: "/apple-touch-icon.png?v1.0"},
      {rel: "manifest", href: "/manifest.webmanifest?v1.0"}
    ]
    display_meta_tags site: "Joy of Rails"
  end
end
