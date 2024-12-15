module Content
  class Image < ApplicationComponent
    attr_reader :src, :alt, :title, :attributes

    def initialize(src, alt: "", title: "", **attributes)
      @src = src
      @alt = alt.presence || File.basename(src, ".*").humanize
      @title = title
      @attributes = attributes
    end

    def view_template
      figure do
        img(alt:, loading: "lazy", **image_attributes, **attributes)
        figcaption { title } if title.present?
      end
    end

    private

    def asset_path(*) = helpers.asset_path(*)

    def image_attributes
      if webp_src?
        {
          src: asset_path(webp_src)
        }
      elsif optimized_src?
        {
          src: asset_path(optimized_src)
        }
      else
        {
          src: asset_path(src)
        }
      end
    end

    def webp_src? = File.exist? Rails.root.join("app", "assets", "images", webp_src)

    def webp_src = "#{dirname}/#{basename}.webp"

    def optimized_src? = File.exist? Rails.root.join("app", "assets", "images", optimized_src)

    def optimized_src = "#{dirname}/#{basename}-opt.#{ext}"

    def ext = File.extname(src)

    def basename = File.basename(src, ".*")

    def dirname = File.dirname(src)
  end
end
