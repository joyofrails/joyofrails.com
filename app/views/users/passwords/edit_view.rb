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
    render Layouts::FrontDoor.new(title: "Reset your password") do
      form_with model: @user,
        url: users_password_path(@password_reset_token),
        class: "space-y-6" do |form|
        div do
          div(class: "flex items-center justify-between") do
            form_label form, :password
          end
          div(class: "mt-2") do
            form_field form, :password_field, :password,
              type: "password",
              autocomplete: "current-password",
              required: true
          end
        end
        div do
          div(class: "flex items-center justify-between") do
            form_label form, :password_confirmation
          end
          div(class: "mt-2") do
            form_field form, :password_field, :password_confirmation,
              type: "password",
              autocomplete: "current-password",
              required: true
          end
        end
        div(class: "pt-6") do
          plain form.button "Update password",
            type: :submit,
            class:
              "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        end
      end
    end
  end

  private

  def form_label(form, *, **)
    plain form.label(*, class: "block text-sm font-medium leading-6", **)
  end

  def form_field(form, method, *, **)
    plain form.send(method, *, class: "block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6", **)
  end
end
