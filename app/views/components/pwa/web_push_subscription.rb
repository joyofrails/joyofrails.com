class Pwa::WebPushSubscription < Phlex::HTML
  include Phlex::Rails::Helpers::ButtonTag

  attr_accessor :web_push_key

  def initialize(web_push_key:)
    @web_push_key = web_push_key
  end

  def view_template
    div(
      data: {
        controller: "pwa-web-push-subscription",
        web_push_key: web_push_key
      },
      class: "pwa-web-push-subscription flex gap-2"
    ) do
      div do
        button(
          data: {
            action: "pwa-web-push-subscription#trySubscribe",
            "pwa-web-push-subscription-target": "subscribeButton"
          },
          disabled: true,
          class: "subscribe button primary"
        ) do
          "Subscribe"
        end
      end

      div do
        button(
          data: {
            action: "pwa-web-push-subscription#unsubscribe",
            "pwa-web-push-subscription-target": "unsubscribeButton"
          },
          disabled: true,
          class: "unsubscribe button primary"
        ) do
          "Unsubscribe"
        end
      end
    end
  end
end
