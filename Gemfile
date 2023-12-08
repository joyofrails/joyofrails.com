source "https://rubygems.org"

ruby "3.2.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Use Tailwind CSS for styling [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails", "~> 2.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Leverage Vite to power the frontend of your Rails app [https://vite-ruby.netlify.app/guide/rails.html]
gem "vite_rails"

# A Ruby gem to load environment variables from `.env` [https://github.com/bkeepers/dotenv]
gem "dotenv-rails"

gem "standard"

# Static site generator for Rails [https://sitepress.cc/getting-started/rails]
gem "sitepress-rails"

# Markdown as static templating language for Rails [https://github.com/sitepress/markdown-rails
gem "markdown-rails"

# Pure Ruby syntaix highlighter [https://github.com/rouge-ruby/rouge
gem "rouge", "~> 4.2"

# Embed SVGs in Rails views and style them with CSS [https://github.com/jamesmartin/inline_svg
gem "inline_svg", "~> 1.9"

# Format ERB files with speed and precision [https://github.com/nebulab/erb-formatter
gem "erb-formatter", "~> 0.6.0", :group => :development

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Preview mail in the browser instead of sending [https://github.com/ryanb/letter_opener]
  gem "letter_opener"
end

group :test do
  # Acceptance test framework for web applications [https://github.com/teamcapybara/capybara]
  gem "capybara"

  # Ruby bindings for Selenium [https://www.rubydoc.info/gems/selenium-webdriver/frames]
  gem "selenium-webdriver"

  # Library for stubbing HTTP requests [https://github.com/bblimke/webmock]
  gem "webmock"
end

group :development, :test do
  # A static analysis security vulnerability scanner for Ruby on Rails applications [https://github.com/presidentbeef/brakeman]
  gem "brakeman"

  # A library for generating fake data [https://github.com/faker-ruby/faker]
  gem "faker"

  # A library for setting up Ruby objects as test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"

  # Intercepts and forwards emails in non-production environments [https://github.com/bigbinary/mail_interceptor]
  gem "mail_interceptor"

  # RSpec for Rails [https://github.com/rspec/rspec-rails]
  gem "rspec-rails"
end
