# frozen_string_literal: true

class Users::MagicSessionTokens::NewView < ApplicationView
  def initialize(user:)
    @user = user
  end

  def view_template
    render FrontDoor::Form.new(title: "Sign in by email") do |layout|
      layout.form_with model: @user, url: users_magic_session_tokens_path do |form|
        fieldset do
          layout.form_label form, :email, "Email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "email",
            required: true
        end
        layout.form_button form, "Send me a magic link"
      end
    end
  end
end
