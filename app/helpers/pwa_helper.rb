module PwaHelper
  # The Ruby WebPush library can produce a padded public key unncessarily.
  # We delete the trailing "=" from the public key so we can subscribe in JavaScript
  # (i.e. registration.pushManager.subscribe({ applicationServerKey: webPushKey }))
  # with the raw key; otherwise we have to convert to a Uint8Array as most docs suggest
  # which is not necessary for the WebPush API and just doesn't feel like a nice API.
  #
  def web_push_key
    Rails.application.credentials.vapid.public_key.delete("=")
  end
end
