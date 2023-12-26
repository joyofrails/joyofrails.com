source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1" # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"

gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "sqlite3", "~> 1.4" # Use sqlite3 as the database for Active Record [https://github.com/sparklemotion/sqlite3-ruby]
gem "redis" # Use Redis adapter to run Action Cable in production [https://github.com/redis/redis-rb]

# Asset management
gem "jsbundling-rails" # Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "sprockets-rails" # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "vite_rails" # Leverage Vite to power the frontend of your Rails app [https://vite-ruby.netlify.app/guide/rails.html]

# Utitlies
# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "kredis" # Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem "dotenv-rails" # A Ruby gem to load environment variables from `.env` [https://github.com/bkeepers/dotenv]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "tzinfo-data", platforms: %i[windows jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

# Rendering
# gem "image_processing" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "inline_svg" # Embed SVGs in Rails views and style them with CSS [https://github.com/jamesmartin/inline_svg
gem "markdown-rails" # Markdown as static templating language for Rails [https://github.com/sitepress/markdown-rails
gem "rouge" # Pure Ruby syntaix highlighter [https://github.com/rouge-ruby/rouge
gem "sitepress-rails" # Static site generator for Rails [https://sitepress.cc/getting-started/rails]

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb [https://github.com/Shopify/bootsnap]

group :development do
  gem "erb-formatter" # Format ERB files with speed and precision [https://github.com/nebulab/erb-formatter
  gem "letter_opener" # Preview mail in the browser instead of sending [https://github.com/ryanb/letter_opener]
  gem "rack-mini-profiler" # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "capybara" # Acceptance test framework for web applications [https://github.com/teamcapybara/capybara]
  gem "selenium-webdriver" # Ruby bindings for Selenium [https://www.rubydoc.info/gems/selenium-webdriver/frames]
  gem "webmock", require: false # Library for stubbing HTTP requests [https://github.com/bblimke/webmock]
end

group :development, :test do
  gem "brakeman", require: false # A static analysis security vulnerability scanner for Ruby on Rails applications [https://github.com/presidentbeef/brakeman]
  gem "bundle-audit", require: false # Patch level verification for Bundler [https://github.com/rubysec/bundler-audit]
  gem "debug", platforms: %i[mri windows] # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "factory_bot_rails" # A library for setting up Ruby objects as test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "faker", require: false # A library for generating fake data [https://github.com/faker-ruby/faker]
  gem "mail_interceptor" # Intercepts and forwards emails in non-production environments [https://github.com/bigbinary/mail_interceptor]
  gem "rails_best_practices", require: false # A code metric tool for Rails projects [https://github.com/flyerhzm/rails_best_practices]
  gem "reek", require: false # Code smell detector for Ruby [https://github.com/troessner/reek]
  gem "rspec-rails" # RSpec for Rails [https://github.com/rspec/rspec-rails]
  gem "standard", require: false # Ruby style guide, linter, and formatter [https://github.com/testdouble/standard]
end
