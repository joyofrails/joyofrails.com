module PwaHelper
  def web_push_key
    Rails.application.credentials.vapid.public_key
  end
end
