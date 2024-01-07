RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers, type: :system

  config.before(:each, type: :system) do
    driven_by(:selenium_chrome_headless)
  end
end
