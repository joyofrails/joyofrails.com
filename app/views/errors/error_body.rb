class Errors::ErrorBody < ApplicationComponent
  def view_template(&)
    div(class: "extend-page-header-bg") do
      div(class: "section-content container py-gap mb-3xl", &)
    end

    section(id: "newsletter-signup") do
      render partial: "users/newsletter_subscriptions/banner"
    end
  end
end
