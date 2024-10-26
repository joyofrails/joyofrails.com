source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", "8.0.0.beta1 " # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"

gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "sqlite3", force_ruby_platform: true # Use sqlite3 as the database for Active Record [https://github.com/sparklemotion/sqlite3-ruby]
gem "sqlite-ulid" # A SQLite extension for generating and working with ULIDs [https://github.com/asg017/sqlite-ulid]

gem "solid_cache" # A database-backed ActiveSupport::Cache::Store [https://github.com/rails/solid_cache]
gem "solid_queue" # A database-backed ActiveJob backend [https://github.com/rails/solid_queue]
gem "solid_cable" # A database-backed ActionCable backend [https://github.com/rails/solid_cable]

# Asset management
gem "propshaft" # Deliver assets for Rails [https://github.com/rails/propshaft]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "vite_rails" # Leverage Vite to power the frontend of your Rails app [https://vite-ruby.netlify.app/guide/rails.html]

# Utilities
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "flipper" # Feature flipping for Ruby [https://www.flippercloud.io/]
gem "flipper-active_record" # ActiveRecord adapter for Flipper [https://www.flippercloud.io/docs/adapters/active-record]
gem "device_detector" # DeviceDetector is a precise and fast user agent parser and device detector written in Ruby [https://github.com/podigee/device_detector]
gem "warden" # General Rack Authentication Framework [https://github.com/wardencommunity/warden]
gem "postmark-rails" # Postmark Rails gem [https://github.com/ActiveCampaign/postmark-rails]
gem "scout_apm" # Scout APM Ruby Agent [https://scoutapm.com]
gem "rails_admin" # RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data [https://github.com/railsadminteam/rails_admin]
gem "addressable" # Addressable is an alternative implementation to URI [https://github.com/sporkmonger/addressable]
gem "ostruct" # OpenStruct is a data structure, similar to a Hash, that allows the definition of arbitrary attributes with their accompanying values

# Rendering
gem "image_processing" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "inline_svg" # Embed SVGs in Rails views and style them with CSS [https://github.com/jamesmartin/inline_svg
gem "rouge" # Pure Ruby syntaix highlighter [https://github.com/rouge-ruby/rouge
gem "sitepress-rails" # Static site generator for Rails [https://sitepress.cc/getting-started/rails]

gem "phlex", "2.0.0.beta2" # An object-oriented view layer. [https://github.com/phlex-ruby/phlex]
gem "phlex-rails", "2.0.0.beta2" # Rails integration for Phlex [https://github.com/phlex-ruby/phlex-rails]

gem "commonmarker", require: false
gem "invisible_captcha" # Unobtrusive and flexible spam protection for Rails apps [https://github.com/markets/invisible_captcha]
gem "color_conversion" # A ruby gem to perform color conversions [https://github.com/devrieda/color_conversion]
gem "meta-tags" # Search Engine Optimization (SEO) for Ruby on Rails applications. [https://github.com/kpumuk/meta-tags]

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb [https://github.com/Shopify/bootsnap]

# Clients
gem "httpx" # An HTTP client library for Ruby [https://gitlab.com/os85/httpx]
gem "honeybadger" # Error monitoring and uptime reporting [https://www.honeybadger.io]
gem "litestream" # Standalone streaming replication for SQLite [https://litestream.io]
gem "web-push" # Web Push library for Ruby [https://github.com/pushpad/web-push]
gem "aws-sdk-s3" # Official AWS Ruby gem for Amazon S3 [https://github.com/aws/aws-sdk-ruby]

# Admin
gem "flipper-ui" # UI for the Flipper gem [https://www.flippercloud.io/docs/ui]
gem "mission_control-jobs" # Dashboard for Active Job [https://github.com/basecamp/mission_control-jobs]

group :development do
  gem "erb_lint", require: false # ERB linting tool [https://github.com/Shopify/erb-lint]
  gem "letter_opener" # Preview mail in the browser instead of sending [https://github.com/ryanb/letter_opener]
  gem "rack-mini-profiler" # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "capybara" # Acceptance test framework for web applications [https://github.com/teamcapybara/capybara]
  gem "cuprite" # Headless Chrome driver for Capybara [https://github.com/rubycdp/cuprite]
  gem "simplecov", require: false # Code coverage for Ruby [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov-tailwindcss", require: false # Alternative HTML formatter for SimpleCov [https://github.com/chiefpansancolt/simplecov-tailwindcss]
  gem "simplecov-cobertura", require: false # Produces Cobertura formatted XML from SimpleCov. [https://github.com/dashingrocket/simplecov-cobertura]
  gem "webmock", require: false # Library for stubbing HTTP requests [https://github.com/bblimke/webmock]

  # Uncomment the following line and bundle to use Selenium with Firefox
  # gem "selenium-webdriver" # Ruby bindings for Selenium [https://www.rubydoc.info/gems/selenium-webdriver/frames]
end

group :development, :test do
  gem "css_parser", require: false # A pure Ruby CSS parser based on the CSS Syntax Level 3 specification [https://github.com/rgrove/crass]
  gem "brakeman", require: false # A static analysis security vulnerability scanner for Ruby on Rails applications [https://github.com/presidentbeef/brakeman]
  gem "bundle-audit", require: false # Patch level verification for Bundler [https://github.com/rubysec/bundler-audit]
  gem "debug", platforms: %i[mri windows] # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "dotenv" # A Ruby gem to load environment variables from `.env` [https://github.com/bkeepers/dotenv]
  gem "factory_bot_rails" # A library for setting up Ruby objects as test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "faker", require: false # A library for generating fake data [https://github.com/faker-ruby/faker]
  gem "rails_best_practices", require: false # A code metric tool for Rails projects [https://github.com/flyerhzm/rails_best_practices]
  gem "reek", require: false # Code smell detector for Ruby [https://github.com/troessner/reek]
  gem "rspec-rails" # RSpec for Rails [https://github.com/rspec/rspec-rails]
  gem "standard", require: false # Ruby style guide, linter, and formatter [https://github.com/testdouble/standard]
  gem "vcr", require: false # Record your test suite's HTTP interactions and replay them during future test runs [https://github.com/vcr/vcr]
  gem "w3c_validators", require: false # W3C HTML and CSS validators [https://github.com/w3c-validators/w3c_validators]
end
