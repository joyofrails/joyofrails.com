# frozen_string_literal: true

class Users::Passwords::EditView < ApplicationView
  def initialize(user:, password_reset_token:)
    @user = user
    @password_reset_token = password_reset_token
  end

  def view_template
    render FrontDoor::Form.new(title: "Reset your password") do |layout|
      layout.form_with model: @user, url: users_password_path(@password_reset_token) do |form|
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
        layout.form_button form, "Update password"
      end
    end
  end
end
