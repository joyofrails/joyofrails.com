# frozen_string_literal: true

class Users::Sessions::NewView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Object
  include Phlex::Rails::Helpers::Routes
  include InlineSvg::ActionView::Helpers

  def initialize(user: User.new)
    @user = user
  end

  def view_template
    render Layouts::FrontDoor.new(title: "Login") do
      form_with model: @user,
        url: users_sessions_path,
        class: "space-y-6" do |form|
        if form.object.errors.any?
          ul do
            form.object.errors.full_messages.each do |message|
              li { message }
            end
          end
        end
        div do
          plain form.label :email,
            "Email address",
            class: "block text-sm font-medium leading-6"
          div(class: "mt-2") do
            plain form.email_field :email,
              autocomplete: "email",
              required: true,
              class:
                "block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          end
        end
        div do
          div(class: "flex items-center justify-between") do
            plain form.label :password,
              class: "block text-sm font-medium leading-6"
          end
          div(class: "mt-2") do
            plain form.password_field :password,
              type: "password",
              autocomplete: "current-password",
              required: true,
              class:
                "block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          end
        end
        div(class: "pt-6") do
          plain form.button "Log in",
            type: :submit,
            class:
              "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        end
      end
    end
  end
end
