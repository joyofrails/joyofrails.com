RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :request
  config.include Rails.application.routes.url_helpers, type: :request

  config.before(:each, type: :request) do
    host! "example.com"
  end
end
