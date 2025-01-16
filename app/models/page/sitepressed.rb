class Page
  module Sitepressed
    extend ActiveSupport::Concern

    Resource = Data.define(
      :request_path,
      :body,
      :title,
      :description,
      :image,
      :meta_image,
      :toc,
      :enable_twitter_widgets,
      :uuid,
      :author,
      :published_on,
      :updated_on
    ) do
      def published_at = published_on&.to_time&.middle_of_day

      def revised_at = updated_on&.to_time&.middle_of_day

      def self.from(sitepress_resource)
        Resource.new \
          request_path: sitepress_resource.request_path,
          body: sitepress_resource.body,
          title: sitepress_resource.data.title,
          description: sitepress_resource.data.description,
          image: sitepress_resource.data.image,
          meta_image: sitepress_resource.data.meta_image,
          toc: sitepress_resource.data.toc,
          enable_twitter_widgets: sitepress_resource.data.enable_twitter_widgets,
          uuid: sitepress_resource.data.uuid,
          author: sitepress_resource.data.author,
          published_on: sitepress_resource.data.published&.to_date,
          updated_on: sitepress_resource.data.updated&.to_date
      end
    end

    NullSitepressResource = Data.define(:request_path) do
      def data = NullSitpressData.new

      def handler = "html"

      def body = ""
    end

    class NullSitpressData
      def title = nil

      def description = nil

      def toc = nil

      def enable_twitter_widgets = nil

      def uuid = nil

      def author = nil

      def published = nil

      def updated = nil

      def image = "articles/placeholder.jpg"

      def meta_image = image
    end

    def resource = Resource.from(sitepress_resource)

    def sitepress_resource = @sitepress_resource ||= Sitepress.site.get(request_path) || NullSitepressResource.new(request_path: request_path)

    def upsert_page_from_sitepress! = upsert_page_from_resource!

    def upsert_page_from_resource! = self.class.upsert_page_from_resource!(resource)

    def resource_missing? = sitepress_resource.is_a?(NullSitepressResource)

    def handler = sitepress_resource.handler

    class_methods do
      # Joy of Rails has logic to represent static pages split between Sitepress
      # and Page models. While not ideal, it currently allows us to live in both
      # worlds depending on the context.  Ultimately, migrating away from
      # Sitepress for indexed content may be what‘s needed.
      #
      def upsert_collection_from_sitepress!(limit: nil)
        enum = SitepressPage.all.resources.lazy.map { |s| Resource.from(s) }
        upserted_at = Time.zone.now

        if limit
          enum = enum.filter do |resource|
            find_by(request_path: resource.request_path).nil?
          end
        end

        enum = enum.map do |resource|
          upsert_page_from_resource!(resource, upserted_at: upserted_at)
        end

        if limit
          enum = enum.take(limit)
        end

        enum.to_a
      end

      def upsert_page_by_request_path!(request_path, **opts) = upsert_page_from_sitepress!(Sitepress.site.get(request_path), **opts)

      def upsert_page_from_sitepress!(sitepress_resource, **opts) = upsert_page_from_resource!(Resource.from(sitepress_resource), **opts)

      def upsert_page_from_resource!(resource, upserted_at: Time.zone.now)
        page = find_or_initialize_by(request_path: resource.request_path)
        page.published_at = resource.published_at if resource.published_at
        page.revised_at = resource.revised_at if resource.revised_at
        page.upserted_at = upserted_at
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
