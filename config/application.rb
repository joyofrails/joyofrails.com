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
require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Joy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks generators rails-wasm])

    # Look up Phlex components under app/views
    config.autoload_paths << "#{root}/app/views"
    config.autoload_paths << "#{root}/app/views/layouts"
    config.autoload_paths << "#{root}/app/views/components"

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

    # Set up solid cable options
    config.solid_cable = ActiveSupport::OrderedOptions.new

    # Set up custom settings
    config.settings = ActiveSupport::OrderedOptions.new

    config.settings.postmark_api_token = Rails.application.credentials.postmark&.api_token || "POSTMARK_API_TEST"
  end
end
