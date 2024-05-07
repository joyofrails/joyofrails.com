if defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.disable_caching = !Rails.application.config.action_controller.perform_caching
end
