class Page
  module Sitepressed
    extend ActiveSupport::Concern

    NullResource = Data.define(:request_path) do
      def data = NullData.new(title: nil, description: nil)

      def body = ""
    end

    NullData = Data.define(:title, :description) do
      def uuid = nil

      def image = "articles/placeholder.jpg"

      def author = nil
    end

    def sitepress_resource = Sitepress.site.get(request_path) ||
      NullResource.new(request_path: request_path)

    def upsert_page_from_sitepress!
      self.class.upsert_page_from_sitepress!(sitepress_resource)
    end

    def resource_missing? = sitepress_resource.is_a?(NullResource)

    def handler = sitepress_resource.handler

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

      def upsert_page_by_request_path!(request_path)
        upsert_page_from_sitepress!(Sitepress.site.get(request_path))
      end

      def upsert_page_from_sitepress!(sitepress_resource)
        page = find_or_initialize_by(request_path: sitepress_resource.request_path)
        page.published_at = sitepress_resource.data.published.to_time.middle_of_day if sitepress_resource.data.published
        page.updated_at = sitepress_resource.data.updated.to_time.middle_of_day if sitepress_resource.data.updated
        page.save!
        page
      end

      def render_html(page, format: :html, assigns: {})
        type = (format == :atom && page.handler.to_sym == :mdrb) ? :"mdrb-atom" : page.handler
        content_type = (format == :atom) ? "application/atom+xml" : "text/html"

        ApplicationController.render(
          inline: page.body,
          type:,
          content_type:,
          layout: false,
          assigns: {format:, current_page: page}.merge(assigns)
        )
      end
    end
  end
end
