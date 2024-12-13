# frozen_string_literal: true

class AdminUsers::Sessions::NewView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  attr_reader :admin_user

  def initialize(admin_user: AdminUser.new)
    @admin_user = admin_user
  end

  def view_template
    render FrontDoor::Form.new(title: "Sign in to your Admin Account") do |layout|
      layout.form_with model: admin_user,
        data: {turbo: false},
        url: admin_users_sessions_path do |form|
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
        layout.form_button form, "Sign in"
        p do
          small do
            link_to "Forgot your password?", new_users_password_path
          end
        end
      end
    end
  end
end
