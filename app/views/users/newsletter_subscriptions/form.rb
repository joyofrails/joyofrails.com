class Users::NewsletterSubscriptions::Form < ApplicationComponent
  include Phlex::Rails::Helpers::EmailField
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes

  include PhlexConcerns::HasInvisibleCaptcha

  def initialize(newsletter_subscription:)
    @newsletter_subscription = newsletter_subscription
  end

  def view_template
    form_with model: @newsletter_subscription.subscriber, url: form_url, method: :post, class: "lg:w-1/2" do |f|
      invisible_captcha
      div(class: "flex flex-row items-center mt-2") do
        div(class: "flex-grow mr-2") do
          f.email_field :email,
            type: :email,
            autocomplete: "off",
            placeholder: "your@joymail.com",
            class: "flex-1 rounded bg-white/5 focus-ring focus:ring-0 ring-1 ring-inset w-full lg:min-w-[36ch]"
        end
        div do
          f.submit "Subscribe", class: "button primary focus-ring"
        end
      end

      if f.object.errors.any?
        div(class: "bg-rose-300 px-2 py-2 mt-1") do
          plain f.object.errors.full_messages.first
        end
      end
    end
  end

  private

  def form_url
    subscriber_namespace = @newsletter_subscription.subscriber.class.name.downcase.pluralize.to_sym # :users
    [subscriber_namespace, :newsletter_subscriptions]
  end
end
