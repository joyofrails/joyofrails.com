source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", "~> 7.2", group: [:default, :wasm] # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"

gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "sqlite3", force_ruby_platform: true # Use sqlite3 as the database for Active Record [https://github.com/sparklemotion/sqlite3-ruby]
gem "activerecord-enhancedsqlite3-adapter" # Enhanced SQLite3 adapter for Active Record [https://github.com/fractaledmind/activerecord-enhancedsqlite3-adapter]
gem "sqlite-ulid" # A SQLite extension for generating and working with ULIDs [https://github.com/asg017/sqlite-ulid]

gem "solid_cache" # A database-backed ActiveSupport::Cache::Store [https://github.com/rails/solid_cache]
gem "solid_queue" # A database-backed ActiveJob backend [https://github.com/rails/solid_queue]
gem "solid_cable" # A database-backed ActionCable backend [https://github.com/rails/solid_cable]

# Asset management
gem "propshaft", group: [:default, :wasm] # Deliver assets for Rails [https://github.com/rails/propshaft]
gem "stimulus-rails", group: [:default, :wasm] # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails", group: [:default, :wasm] # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "vite_rails", group: [:default, :wasm] # Leverage Vite to power the frontend of your Rails app [https://vite-ruby.netlify.app/guide/rails.html]

# Utilities
gem "bcrypt", "~> 3.1.7", group: [:default, :wasm] # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "flipper", group: [:default, :wasm] # Feature flipping for Ruby [https://www.flippercloud.io/]
gem "flipper-active_record" # ActiveRecord adapter for Flipper [https://www.flippercloud.io/docs/adapters/active-record]
gem "device_detector" # DeviceDetector is a precise and fast user agent parser and device detector written in Ruby [https://github.com/podigee/device_detector]
gem "warden", group: [:default, :wasm] # General Rack Authentication Framework [https://github.com/wardencommunity/warden]
gem "postmark-rails" # Postmark Rails gem [https://github.com/ActiveCampaign/postmark-rails]
gem "scout_apm" # Scout APM Ruby Agent [https://scoutapm.com]

# Rendering
gem "image_processing", group: [:default, :wasm] # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "inline_svg" # Embed SVGs in Rails views and style them with CSS [https://github.com/jamesmartin/inline_svg
gem "rouge", group: [:default, :wasm] # Pure Ruby syntaix highlighter [https://github.com/rouge-ruby/rouge
gem "sitepress-rails", group: [:default, :wasm] # Static site generator for Rails [https://sitepress.cc/getting-started/rails]
gem "phlex-rails", group: [:default, :wasm] # An object-oriented alternative to ActionView for Ruby on Rails. [https://github.com/phlex-ruby/phlex-rails]
gem "commonmarker", require: false
gem "invisible_captcha", group: [:default, :wasm] # Unobtrusive and flexible spam protection for Rails apps [https://github.com/markets/invisible_captcha]
gem "color_conversion", group: [:default, :wasm] # A ruby gem to perform color conversions [https://github.com/devrieda/color_conversion]
gem "meta-tags", group: [:default, :wasm] # Search Engine Optimization (SEO) for Ruby on Rails applications. [https://github.com/kpumuk/meta-tags]

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb [https://github.com/Shopify/bootsnap]

# Clients
gem "httpx" # An HTTP client library for Ruby [https://gitlab.com/os85/httpx]
gem "honeybadger" # Error monitoring and uptime reporting [https://www.honeybadger.io]
gem "litestream" # Standalone streaming replication for SQLite [https://litestream.io]
gem "web-push" # Web Push library for Ruby [https://github.com/pushpad/web-push]
gem "fog-aws", require: false # Module for the 'fog' gem to support Amazon Web Services [https://github.com/fog/fog-aws]
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

group :wasm do
  gem "activerecord-nulldb-adapter" # Use nulldb as the database for Active Record [https://github.com/nulldb/nulldb]
  gem "tzinfo-data" # WASM needs to include zoneinfo files, so bundle the tzinfo-data gem
  gem "ruby_wasm", "~> 2.5" # Building WebAssembly modules in Ruby [https://github.com/ruby/ruby.wasm]
end

group :browser do
  gem "js" # JavaScript bindings for ruby.wasm [https://github.com/ruby/ruby.wasm/blob/main/packages/gems/js]
end
