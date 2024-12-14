module Content
  class Image < ApplicationComponent
    attr_reader :src, :alt, :title, :attributes

    def initialize(src, alt: "", title: "", **attributes)
      @src = src
      @alt = alt
      @title = title
      @attributes = attributes
    end

    def view_template
      figure(**attributes) do
        img(alt:, **image_attributes)
        figcaption { title }
      end
    end

    private

    def asset_path(*) = helpers.asset_path(*)

    def image_attributes
      if WEBP_ELIGIBLE.include?(ext)
        {
          src: asset_path(webp_src("800w")),
          srcset: webp_srcset,
          sizes: WEBP_SIZES
        }
      else
        {
          src: asset_path(src)
        }
      end
    end

    def webp_src(*suffixes)
      "#{dirname}/#{([basename] + suffixes).join("-")}.webp"
    end

    WEBP_ELIGIBLE = %w[.jpg .jpeg .png .webp].freeze
    WEBP_WIDTHS = %w[400w 800w].freeze
    WEBP_SIZES = "(max-width: 640px) 100vw, (min-width: 641px) 50vw"

    def webp_srcset
      WEBP_WIDTHS.map { |size| "#{asset_path(webp_src(size))} #{size}" }
    end

    def ext = File.extname(src)

    def basename = File.basename(src, ".*")

    def dirname = File.dirname(src)
  end
end
