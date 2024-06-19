require "warden"
require_relative "../../app/lib/warden_extensions/setup"
require_relative "../../app/lib/warden_extensions/strategies/password"
require_relative "../../app/lib/warden_extensions/strategies/magic_session"

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.failure_app = proc { |env|
    env["REQUEST_METHOD"] = "GET"
    scope_class = env["warden.options"][:scope].to_s.classify.pluralize.constantize
    scope_class.const_get(:SessionsController).action(:fail).call(env)
  }
  manager.default_strategies :password, :magic_session
end

WardenExtensions::Setup.configure_manager
