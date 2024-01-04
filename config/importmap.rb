# Pin npm packages by running ./bin/importmap

# Credit: https://stackoverflow.com/questions/76116427/rails-7-stimulusjs-relative-import-working-on-dev-but-not-production
def pin_all_relative(dir_name)
  pin_all_from "app/javascript/#{dir_name}",
    under: "#{Rails.application.config.assets.prefix}/#{dir_name}",
    to: dir_name
end

pin "application"
pin_all_relative "controllers"
pin_all_relative "initializers"
pin_all_relative "utils"

pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.0
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.0
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.1.2
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
