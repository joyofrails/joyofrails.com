class Errors::ErrorBody < ApplicationComponent
  def view_template(&)
    div(class: "extend-page-header-bg") do
      div(class: "section-content container py-gap mb-3xl", &)
    end

    section(id: "newsletter-signup") do
      render Users::NewsletterSubscriptions::Banner.new do
        view_context.turbo_frame_tag :newsletter_subscription, src: new_users_newsletter_subscription_path, data: {"turbo-permanent": true}
      end
    end
  end
end
