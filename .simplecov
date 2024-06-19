# frozen_string_literal: true

if ENV["CI"]
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
else
  require "simplecov-tailwindcss"
  SimpleCov.formatter = SimpleCov::Formatter::TailwindFormatter
end

SimpleCov.profiles.define :joyofrails do
  load_profile "test_frameworks"

  add_group "Controllers", "app/controllers"
  add_group "Content", "app/content"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", "app/jobs"
  add_group "Libraries", "lib"
  add_group "Mailers", "app/mailers"
  add_group "Models", "app/models"
  add_group "Notifiers", "app/notifiers"
  add_group "Views", "app/views"

  add_filter %r{^/bin/}
  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter %r{^/log/}
  add_filter %r{^/storage/}
  add_filter %r{^/node_modules/}
  add_filter %r{^/docs/}
  add_filter %r{^/public/}
  add_filter %r{^/tmp/}
  add_filter %r{^/vendor/}

  add_filter %r{^/app/assets/}
  add_filter %r{^/app/javascript/}

  add_filter %r{^/lib/assets/}
  add_filter %r{^/lib/rails-wasm/}

  track_files "{app,lib}/**/*.rb"
end

SimpleCov.start :joyofrails
