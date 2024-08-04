class Users::Registrations::NewView < ApplicationView
  include PhlexConcerns::HasInvisibleCaptcha

  def initialize(user:)
    @user = user
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Create a new account") do |layout|
      layout.form_with model: @user,
        url: users_registration_path do |form|
        invisible_captcha
        fieldset do
          layout.form_label form, :email, "Email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "off",
            required: true
        end
        fieldset do
          layout.form_label form, :password
          layout.form_field form, :password_field, :password,
            type: "password",
            autocomplete: "off",
            required: true
        end
        fieldset do
          layout.form_label form, :password_confirmation
          layout.form_field form, :password_field, :password_confirmation,
            type: "password",
            autocomplete: "off",
            required: true
        end
        layout.form_button form, "Sign up"
        if form.object.errors.any?
          div(class: "bg-error callout") do
            plain form.object.errors.full_messages.join(". ")
          end
        end
      end
    end
  end
end
