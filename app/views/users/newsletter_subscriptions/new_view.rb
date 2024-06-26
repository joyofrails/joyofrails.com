# frozen_string_literal: true

class Users::NewsletterSubscriptions::NewView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(newsletter_subscription:)
    @newsletter_subscription = newsletter_subscription
  end

  def view_template
    render Users::NewsletterSubscriptions::Banner.new do
      turbo_frame_tag :newsletter_subscription do
        if helpers.user_signed_in?
          div do
            render Users::NewsletterSubscriptions::SubscribeButton.new
          end
        else
          render Users::NewsletterSubscriptions::Form.new(newsletter_subscription: @newsletter_subscription)
        end
      end
    end
  end
end
