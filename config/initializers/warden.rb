require_relative "../../app/lib/warden/setup"
require_relative "../../app/lib/warden/password_strategy"

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.failure_app = proc { |env|
    env["REQUEST_METHOD"] = "GET"
    AdminUsers::SessionsController.action(:fail).call(env)
  }
  manager.default_strategies :password # needs to be defined
end
