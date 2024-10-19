# frozen_string_literal: true

class Users::Passwords::NewView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes

  def initialize(user:)
    @user = user
  end

  def view_template
    render FrontDoor::Form.new(title: "Forgot your password?") do |layout|
      layout.form_with model: @user, url: users_passwords_path do |form|
        fieldset do
          layout.form_label form, :email, "Email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "email",
            required: true
        end
        layout.form_button form, "Send me password reset instructions"
      end
    end
  end
end
