class Users::Registrations::NewView < ApplicationView
  include Phlex::Rails::Helpers::EmailField
  include Phlex::Rails::Helpers::FormWith
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
        form_with model: @user,
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
              form_label form, :email, "Email address"
            end
            div(class: "mt-2") do
              form_field form, :email_field, :email,
                autocomplete: "email",
                required: true
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
            plain form.button "Sign up",
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
