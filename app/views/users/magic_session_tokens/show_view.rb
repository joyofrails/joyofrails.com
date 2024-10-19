class Users::MagicSessionTokens::ShowView < ApplicationView
  def initialize(user:, magic_session_token:)
    @user = user
    @magic_session_token = magic_session_token
  end

  def view_template
    render FrontDoor::Form.new(title: "Click to sign in") do |layout|
      layout.form_with model: @user,
        url: users_sessions_path(token: @magic_session_token) do |form|
        layout.form_button form, "Sign in now"
      end
    end
  end
end
