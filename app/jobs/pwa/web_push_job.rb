class Pwa::WebPushJob < ApplicationJob
  queue_as :default

  def perform(title:, message:, subscription:)
    message_json = {
      title: title,
      body: message,
      icon: icon_url
    }.to_json

    response = WebPush.payload_send(
      message: message_json,
      endpoint: subscription["endpoint"],
      p256dh: subscription["keys"]["p256dh"],
      auth: subscription["keys"]["auth"],
      vapid: {
        subject: Rails.configuration.x.vapid.subject,
        public_key: Rails.configuration.x.vapid.public_key,
        private_key: Rails.configuration.x.vapid.private_key
      }
    )

    Rails.logger.info "Web push sent to #{subscription["endpoint"]} with message: #{message.inspect}"
    Rails.logger.info "Web push response: #{response}"
  end

  def icon_url
    ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
  end
end
