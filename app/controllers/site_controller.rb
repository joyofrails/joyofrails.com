class SiteController < Sitepress::SiteController
  include CurrentPage

  before_action do
    @current_page = Page.find_or_initialize_by(request_path: request.path)
  end

  # This is the default controller for Sitepress. It is used to render the pages of the site.
  # We prefer not to override this method but instead use the hooks provided by Sitepress below.
  #
  # render_resource is a helper method provided by Sitepress to render the current resource.
  # requested_resource is the Sitepress::Resource object that represents the current page.
  #

  def show
    super
  end

  protected

  # Override method provided by Sitepress to render the page.
  #
  # Send the inline rendered, post-processed string into the Rails rendering method that actually sends
  # the output to the end-user as a web response.
  #
  # @param rendition [Sitepress::Rendition] Rendered representation of current_resource
  #
  def render_resource_with_handler(resource)
    last_modified_at = @current_page&.upserted_at || @current_page&.created_at || current_resource.asset.updated_at || Time.now

    if skip_http_cache? || stale?(resource.body, last_modified: last_modified_at.utc, public: true)
      super
    end
  end

  def skip_http_cache?
    Rails.configuration.skip_http_cache || current_path?(root_path) || custom_color_scheme? || custom_syntax_highlight?
  end

  def current_path?(path)
    request.path == path
  end
end
