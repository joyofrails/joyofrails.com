Rails.application.configure do
  config.skip_http_cache = ENV["SKIP_HTTP_CACHE"] == "true"
end
