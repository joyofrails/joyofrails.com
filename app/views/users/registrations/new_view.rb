class Users::Registrations::NewView < ApplicationView
  def initialize(user:)
    @user = user
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Create a new account") do |layout|
      layout.form_with model: @user,
        url: users_registration_path do |form|
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
        fieldset do
          layout.form_label form, :password
          layout.form_field form, :password_field, :password,
            type: "password",
            autocomplete: "current-password",
            required: true
        end
        fieldset do
          layout.form_label form, :password_confirmation
          layout.form_field form, :password_field, :password_confirmation,
            type: "password",
            autocomplete: "current-password",
            required: true
        end
        layout.form_button form, "Sign up"
      end
    end
  end
end
