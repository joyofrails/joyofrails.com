# frozen_string_literal: true

class Users::Registrations::EditView < ApplicationView
  def initialize(user:)
    @user = user
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Edit your account") do |layout|
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
          layout.form_label form, :email, "Current email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "email",
            disabled: true
        end
        form.fields_for :email_exchanges do |email_form|
          fieldset do
            layout.form_label email_form, :email, "Change email address"
            layout.form_field email_form, :email_field, :email,
              autocomplete: "email",
              required: false
          end
        end
        fieldset do
          layout.form_label form, :password
          layout.form_field form, :password_field, :password,
            type: "password",
            autocomplete: "current-password",
            required: false
        end
        fieldset do
          layout.form_label form, :password_confirmation
          layout.form_field form, :password_field, :password_confirmation,
            type: "password",
            autocomplete: "current-password",
            required: false
        end
        fieldset do
          layout.form_label form, :password_challenge, "Current password to confirm changes"
          layout.form_field form, :password_field, :password_challenge,
            type: "password",
            autocomplete: "current-password",
            required: false
        end
        layout.form_button form, "Update account"
      end
    end
  end
end
