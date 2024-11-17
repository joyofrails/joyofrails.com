class Page
  module Sitepressed
    extend ActiveSupport::Concern

    NullResource = Data.define(:request_path) do
      def data = NullData.new(title: nil, description: nil)
    end

    NullData = Data.define(:title, :description)

    def sitepress_resource = Sitepress.site.get(request_path) ||
      NullResource.new(request_path: request_path)

    def upsert_page_from_sitepress!
      self.class.upsert_page_from_sitepress!(sitepress_resource)
    end

    class_methods do
      # We currently have a dual system of content management between Sitepress and
      # Page models for handling static pages While not ideal, it currently allows
      # us to live in both worlds depending on the context.  Ultimately, migrating
      # away from Sitepress for indexed content may be what‘s needed, but keeping
      # the split personality for now.
      #
      def upsert_collection_from_sitepress!(limit: nil)
        enum = SitepressPage.all.resources.lazy

        if limit
          enum = enum.filter do |sitepress_resource|
            find_by(request_path: sitepress_resource.request_path).nil?
          end
        end

        enum = enum.map do |sitepress_resource|
          upsert_page_from_sitepress!(sitepress_resource)
        end

        if limit
          enum = enum.take(limit)
        end

        enum.to_a
      end

      def upsert_page_from_sitepress!(sitepress_resource)
        page = find_or_initialize_by(request_path: sitepress_resource.request_path)
        page.published_at = sitepress_resource.data.published.to_time.middle_of_day if sitepress_resource.data.published
        page.updated_at = sitepress_resource.data.updated.to_time.middle_of_day if sitepress_resource.data.updated
        page.save!
        page
      end
    end
  end
end
