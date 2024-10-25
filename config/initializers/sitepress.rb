Rails.application.configure do
  # Workaround for regression introduced after upgrading to Sitepress 4.0.5
  # Introduced by this commit: https://github.com/sitepress/sitepress/commit/5cc78334d2a0688c9b60252c06c43da884df50f6
  # Described in this issue: https://github.com/sitepress/sitepress/issues/64
  #
  # This workaround is necessary to ensure that Sitepress can find the correct
  # handler for a given file extension, otherwise pages with non-default
  # extensions, like .mdrb will 404.
  #
  config.after_initialize do
    Sitepress::Path.handler_extensions = ActionView::Template::Handlers.extensions
  end
end
