module PwaHelper
  def web_push_key
    Base64.encode64(Base64.urlsafe_decode64(Rails.application.credentials.vapid.public_key))
  end
end
