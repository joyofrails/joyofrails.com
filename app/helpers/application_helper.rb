module ApplicationHelper
  def seo_meta_tags
    favicon_path = Rails.env.local? ? asset_path("app-icons/favicon-local.ico") : asset_path("app-icons/favicon.ico")
    favicon_svg_path = Rails.env.local? ? asset_path("app-icons/icon-local.svg") : asset_path("app-icons/icon.svg")
    apple_touch_icon_path = Rails.env.local? ? asset_path("app-icons/apple-touch-icon-local.png") : asset_path("app-icons/apple-touch-icon.png")
    set_meta_tags icon: [
      {rel: "icon", href: favicon_path, sizes: "32x32"},
      {rel: "icon", href: favicon_svg_path, type: "image/svg+xml"},
      {rel: "apple-touch-icon", href: apple_touch_icon_path}
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
    set_meta_tags canonical: url_for(only_path: false, overwrite_params: nil) unless meta_tags[:canonical]
    display_meta_tags \
      site: Rails.configuration.x.application_name,
      description: "Interactive tutorials on Ruby, Ruby on Rails, Stimulus, " \
      "Turbo, Turbo Frames, Turbo Streams, Hotwire, Active Record, Action Pack, Active Job, and more."
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end
end
