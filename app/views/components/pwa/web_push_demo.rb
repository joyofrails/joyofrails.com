class Pwa::WebPushDemo < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::Routes

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
      render Pwa::WebPushSubscription.new

      p(
        data_pwa_web_push_demo_target: "status",
        class: "mt-6 mb-4 italic"
      )

      p(class: "mt-6 mb-4") do
        "Try sending a web push notification using the form below. The first text box will be used as a title and the second text box represents the message body. Click the button to send a push notification to yourself."
      end

      form_for :web_push,
        url: pwa_web_pushes_path,
        data: {
          "pwa-web-push-demo-target": "sendDemoPushForm"
        } do |f|
        f.hidden_field :subscription,
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
          f.text_field :title, value: "Joy of Rails"
          f.text_field :message, value: "Hello World"
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
