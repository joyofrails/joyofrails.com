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

  # Hook method provided by Sitepress to process the current "rendition".
  #
  # This is to be used by end users if they need to do any post-processing on the rendering page.
  # For example, the user may use Nokogiri to parse static HTML pages and hook it into the asset pipeline.
  # They may also use tools like `HTMLPipeline` to process links from a markdown renderer.
  #
  # For example, the rendition could be modified via `Nokogiri::HTML5::DocumentFragment(rendition)`.
  #
  # @param rendition [Sitepress::Rendition] Rendered representation of current_resource
  #
  def process_rendition(rendition)
  end

  # Hook method provided by Sitepress to render the page.
  #
  # Send the inline rendered, post-processed string into the Rails rendering method that actually sends
  # the output to the end-user as a web response.
  #
  # @param rendition [Sitepress::Rendition] Rendered representatio of current_resource
  #
  def post_render(rendition)
    if skip_http_cache? || stale?(rendition.source, last_modified: current_resource.asset.updated_at.utc, public: true)
      render body: rendition.output, content_type: rendition.mime_type
    end
  end

  def skip_http_cache?
    Rails.configuration.skip_http_cache || current_path?(root_path) || custom_color_scheme? || custom_syntax_highlight?
  end

  def current_path?(path)
    request.path == path
  end
end
