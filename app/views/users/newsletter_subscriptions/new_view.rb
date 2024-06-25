# frozen_string_literal: true

class Users::NewsletterSubscriptions::NewView < ApplicationView
  def initialize(user:)
    @user = user
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Create a new account") do |layout|
      layout.form_with model: @user,
        url: users_newsletter_subscriptions_path do |form|
        if form.object.errors.any?
          ul do
            form.object.errors.full_messages.each do |message|
              li { message }
            end
          end
        end
        fieldset do
          layout.form_label form, :email, "Email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "email",
            required: true
        end
        layout.form_button form, "Subscribe"
      end
    end
  end
end
