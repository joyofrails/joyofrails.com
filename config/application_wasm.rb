require_relative "boot"

require "rails"

require "dotenv/load" if Rails.env.development? || Rails.env.test?

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# FIXME: Bundler.require doesn't work in Wasm
require "sprockets/rails"
require "turbo-rails"
require "stimulus-rails"
require "vite_rails"
require "flipper"
require "sitepress-rails"
require "markdown-rails"
require "inline_svg"

module Joy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks generators rails-wasm])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Log to STDOUT
    if ENV["RAILS_LOG_TO_STDOUT"] == "true"
      config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new($stdout))
    end
  end
end
