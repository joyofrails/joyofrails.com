class Users::NewsletterSubscriptions::UnsubscribeButton < ApplicationComponent
  include Phlex::Rails::Helpers::ButtonTo

  # TODO: Make this button work for users who are not signed in—first we need to figure out when to show it for them
  def view_template
    button_to "Unsubscribe", unsubscribe_users_newsletter_subscriptions_path, class: "button secondary",
      form: {data: {turbo_confirm: "Just confirming: Are you sure you want to unsubscribe?"}}
  end
end
