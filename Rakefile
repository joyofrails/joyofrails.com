# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task default: %i[
  standard
  spec
  db:seed
  vitest:run
  brakeman:run
  bundler:audit
]

# Tasks to consider later
# license_finder
# reek
