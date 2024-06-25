# frozen_string_literal: true

class Users::NewsletterSubscriptions::ShowView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(newsletter_subscription:)
    @newsletter_subscription = newsletter_subscription
  end

  def view_template
    render Users::NewsletterSubscriptions::Banner.new do
      turbo_frame_tag :newsletter_subscription do
        div(class: "bg-success callout flex flex-row items-center mt-2") do
          div(class: "flex-grow mr-2") do
            plain "You are subscribed to the Joy of Rails newsletter!"
            if @newsletter_subscription.subscriber.needs_confirmation?
              whitespace
              plain "Please check your email for a confirmation link."
              # TODO:
              # Didn't receive it?
              # = button_to "Resend confirmation email", users_confirmations_path, params: { user: { email: newsletter_subscription.subscriber.email }}, class: "button primary"
            end
          end
        end
      end
    end
  end
end
