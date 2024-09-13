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

  def manifest_icons
    [
      {
        "src" => "/pwa-manifest/icon-64.png",
        "type" => "image/png",
        "sizes" => "64x64"
      },
      {
        "src" => "/pwa-manifest/icon-192-maskable.png",
        "type" => "image/png",
        "sizes" => "192x192",
        "purpose" => "maskable"
      },
      {
        "src" => "/pwa-manifest/icon-192.png",
        "type" => "image/png",
        "sizes" => "192x192",
        "purpose" => "any"
      },
      {
        "src" => "/pwa-manifest/icon-512-maskable.png",
        "type" => "image/png",
        "sizes" => "512x512",
        "purpose" => "maskable"
      },
      {
        "src" => "/pwa-manifest/icon-512.png",
        "type" => "image/png",
        "sizes" => "512x512",
        "purpose" => "any"
      }
    ]
  end

  def manifest_related_applications
    [
      {
        "platform" => "webapp",
        :url => root_url + "manifest.json"
      }
    ]
  end
end
