require_relative "../../app/lib/warden/setup"
require_relative "../../app/lib/warden/password_strategy"

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.failure_app = proc { |env|
    env["REQUEST_METHOD"] = "GET"
    Users::SessionsController.action(:new).call(env)
  }
  manager.default_strategies :password # needs to be defined
  # Optional Settings (see Warden wiki)
  # manager.scope_defaults :admin, strategies: [:password]
  # manager.default_scope = :admin # optional default scope
  # manager.intercept_401 = false # Warden will intercept 401 responses, which can cause conflicts
end
