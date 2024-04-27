class Pwa::WebPushDemo < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::Routes

  attr_accessor :web_push_key

  def initialize(web_push_key:)
    @web_push_key = web_push_key
  end

  def view_template
    div(
      data: {
        controller: "pwa-web-push-demo",
        action: "pwa-web-push-subscription:subscription-changed->pwa-web-push-demo#onSubscriptionChanged" \
                " " \
                "pwa-web-push-subscription:subscription-error->pwa-web-push-demo#onError"
      },
      class: "not-prose"
    ) do
      render Pwa::WebPushSubscription.new(web_push_key: web_push_key)

      p(class: "mt-6 mb-4") do
        "Try sending a web push notificaiton using the form below."
      end

      form_for :web_push,
        url: pwa_web_pushes_path,
        data: {
          "pwa-web-push-demo-target": "sendDemoPushForm"
        } do |f|
        plain f.hidden_field :subscription,
          data: {
            "pwa-web-push-demo-target": "subscriptionField"
          }

        fieldset(
          data: {
            "pwa-web-push-demo-target": "sendPushDemoFieldset"
          },
          class: "flex flex-wrap gap-2",
          disabled: true
        ) do
          plain f.text_field :title, value: "Joy of Rails"
          plain f.text_field :message, value: "Hello World"
          button(class: "button primary") do
            "Send push notification to myself"
          end
        end
      end

      div(
        data_pwa_web_push_demo_target: "error",
        class: "bg-pink-300 text-pink-700 px-2 py-1 rounded-sm mt-8 hidden"
      )
    end
  end
end
