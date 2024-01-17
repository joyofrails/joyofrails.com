module PwaHelper
  def vapid_public_key_bytes
    Base64.urlsafe_decode64(Rails.application.credentials.vapid.public_key).bytes
  end
end
