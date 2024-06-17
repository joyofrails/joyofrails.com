require "capybara/cuprite"

# Default to headless Chrome with Cuprite
#
# To run cuprite in Chrome browser
# HEADLESS=false bin/rspec
#
# To run with the inspector, use page.driver.debug in test and run
# INSPECTOR=true bin/rspec

Capybara.default_max_wait_time = 5
Capybara.disable_animation = true

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :system
  config.include Rails.application.routes.url_helpers, type: :system
  config.include ActiveJob::TestHelper

  config.before(:each, type: :system) do
    driven_by(:cuprite, screen_size: [1440, 810], options: {
      js_errors: true,
      headless: %w[0 false].exclude?(ENV["HEADLESS"]),
      inspector: %w[1 true].include?(ENV["INSPECTOR"]),
      slowmo: ENV["SLOWMO"]&.to_f,
      process_timeout: 15,
      timeout: 10,
      browser_options: ENV["CI"] ? {"no-sandbox" => nil} : {}
    })
  end

  config.filter_gems_from_backtrace("capybara", "cuprite", "ferrum")
end
