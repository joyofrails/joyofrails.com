class Users::Confirmations::EditView < ApplicationView
  def initialize(user:, confirmation_token:)
    @user = user
    @confirmation_token = confirmation_token
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Click to confirm") do |layout|
      layout.form_with model: @user,
        url: users_confirmation_path(@confirmation_token) do |form|
        layout.form_button form, "Confirm email: #{@user.email}"
      end
    end
  end
end
