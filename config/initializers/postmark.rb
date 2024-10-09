Rails.application.configure do
  config.x.postmark.api_token = Rails.application.credentials.dig(:postmark, :api_token) || "POSTMARK_API_TEST"

  config.action_mailer.postmark_settings = {api_token: config.x.postmark.api_token}

  if Rails.env.local? && ENV["ENABLE_POSTMARK_IN_DEV"] == "true"
    config.action_mailer.delivery_method = :postmark
  end
end
