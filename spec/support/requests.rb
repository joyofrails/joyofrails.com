module RequestSpecHelpers
  def document
    @document ||= Capybara.string(response.body)
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :request
  config.include Rails.application.routes.url_helpers, type: :request

  config.before(:each, type: :request) do
    host! "example.com"
  end

  config.include RequestSpecHelpers, type: :request
end
