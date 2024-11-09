OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN", "REPLACE_ME")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID", "REPLACE_ME")
  config.log_errors = Rails.env.local?
end
