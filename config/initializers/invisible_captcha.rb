require "invisible_captcha"

InvisibleCaptcha.setup do |config|
  # We need to deal with invisible captcha for specs
  # https://github.com/markets/invisible_captcha?tab=readme-ov-file#testing-your-controllers
  if Rails.env.test?
    config.timestamp_enabled = false
    config.spinner_enabled = false
    config.honeypots = ["my_honeypot_field"]
  end
end
