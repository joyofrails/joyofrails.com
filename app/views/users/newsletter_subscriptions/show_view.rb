# frozen_string_literal: true

class Users::NewsletterSubscriptions::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(newsletter_subscription:, show_unsubscribe: false)
    @newsletter_subscription = newsletter_subscription
    @show_unsubscribe = show_unsubscribe
  end

  def view_template
    render Users::NewsletterSubscriptions::Banner.new do
      turbo_frame_tag :newsletter_subscription do
        if @newsletter_subscription.persisted?
          div(class: "bg-success callout flex flex-row items-center mt-2") do
            div(class: "flex-grow mr-2") do
              subscribed_message
            end

            if @show_unsubscribe && helpers.user_signed_in?
              render Users::NewsletterSubscriptions::UnsubscribeButton.new
            end
          end
        elsif helpers.user_signed_in?
          div do
            render Users::NewsletterSubscriptions::SubscribeButton.new
          end
        end
      end
    end
  end

  def subscribed_message
    link_to("Thank you", users_thank_you_path, class: "font-bold", data: {turbo_frame: "_top"})
    whitespace
    plain "for subscribing to the Joy of Rails newsletter!"
    if @newsletter_subscription.subscriber.needs_confirmation?
      whitespace
      plain "Please check your email for a confirmation link."
      # TODO:
      # Didn't receive it?
      # = button_to "Resend confirmation email", users_confirmations_path, params: { user: { email: newsletter_subscription.subscriber.email }}, class: "button primary"
    end
  end
end
