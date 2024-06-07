# frozen_string_literal: true

class Users::Passwords::EditView < Phlex::HTML
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes
  include InlineSvg::ActionView::Helpers

  def initialize(user:, password_reset_token:)
    @user = user
    @password_reset_token = password_reset_token
  end

  def view_template
    render Layouts::FrontDoor.new(title: "One-click confirm") do
      form_with model: @user,
        url: users_password_resets_path(@password_reset_token),
        class: "space-y-6" do |form|
        div(class: "pt-6") do
          plain form.button "Confirm email: #{@user.email}",
            type: :submit,
            class:
              "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        end
      end
    end
  end
end
