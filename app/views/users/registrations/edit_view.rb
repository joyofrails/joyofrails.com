# frozen_string_literal: true

class Users::Registrations::EditView < ApplicationView
  include Phlex::Rails::Helpers::EmailField
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::FieldsFor
  include Phlex::Rails::Helpers::Label
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::PasswordField
  include Phlex::Rails::Helpers::Routes
  include InlineSvg::ActionView::Helpers

  def initialize(user:)
    @user = user
  end

  def view_template
    div(class: "flex min-h-full flex-col justify-center px-6 py-12 lg:px-8") do
      div(class: "sm:mx-auto sm:w-full sm:max-w-sm text-joy-title") do
        plain inline_svg_tag "joy-logo.svg",
          class: "fill-current mx-auto",
          style: "max-width: 64px;",
          alt: "Joy of Rails"
        h2(
          class: "mt-4 text-center text-2xl font-bold leading-9 tracking-tight"
        ) { "Create a new account" }
      end
      div(class: "mt-10 sm:mx-auto sm:w-full sm:max-w-sm") do
        form_for @user,
          url: users_registration_path,
          class: "space-y-6" do |form|
          if form.object.errors.any?
            ul do
              form.object.errors.full_messages.each do |message|
                li { message }
              end
            end
          end
          div do
            div(class: "flex items-center justify-between") do
              form_label form, :email, "Current email address"
            end
            div(class: "mt-2") do
              form_field form, :email_field, :email,
                autocomplete: "email",
                disabled: true
            end
          end
          form.fields_for :email_exchanges do |email_form|
            div do
              div(class: "flex items-center justify-between") do
                form_label email_form, :email, "Change email address"
              end
              div(class: "mt-2") do
                form_field email_form, :email_field, :email,
                  autocomplete: "email",
                  required: false
              end
            end
          end
          div do
            div(class: "flex items-center justify-between") do
              form_label form, :password
            end
            div(class: "mt-2") do
              form_field form, :password_field, :password,
                type: "password",
                autocomplete: "current-password",
                required: false
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
                required: false
            end
          end
          div do
            div(class: "flex items-center justify-between") do
              form_label form, :current_password, "Current password to confirm changes"
            end
            div(class: "mt-2") do
              form_field form, :password_field, :current_password,
                type: "password",
                autocomplete: "current-password",
                required: false
            end
          end
          div(class: "pt-6") do
            plain form.button "Update account",
              type: :submit,
              class:
                "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          end
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
