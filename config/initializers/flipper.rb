require "flipper"

Rails.application.configure do
  config.flipper.memoize = false
end

if Rails.env.development?
  Flipper.enable(:user_registration)
  Flipper.enable(:snippets)
  Flipper.enable(:example_posts)
end
