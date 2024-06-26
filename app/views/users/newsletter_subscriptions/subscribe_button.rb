class Users::NewsletterSubscriptions::SubscribeButton < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo

  def view_template
    return plain "" unless helpers.user_signed_in?

    if helpers.current_user.subscribed_to_newsletter?
      link_to "Manage subscription", users_newsletter_subscriptions_path, class: "button secondary"
    else
      button_to "Subscribe", subscribe_users_newsletter_subscriptions_path, class: "button primary"
    end
  end
end
