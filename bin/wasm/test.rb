ENV["RAILS_ENV"] = "wasm"
ENV["RAILS_LOG_TO_STDOUT"] = "true"
ENV["SECRET_KEY_BASE"] = "secret"
ENV["ACTIVE_RECORD_ADAPTER"] = "nulldb"

require "/bundle/setup"
require "/lib/rails-wasm/joy"

request = Rack::MockRequest.env_for("http://localhost:3000", {"HTTP_HOST" => "localhost"})

puts Rails.application.call(request)
