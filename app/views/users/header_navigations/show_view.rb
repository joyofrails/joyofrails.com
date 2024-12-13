module Users
  module HeaderNavigations
    class ShowView < ApplicationView
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo
      include PhlexConcerns::FlexBlock

      attr_reader :current_user, :current_admin_user

      def initialize(current_user:, current_admin_user:)
        @current_user = current_user
        @current_admin_user = current_admin_user
      end

      def view_template
        turbo_frame_tag :header_navigation, data: {turbo_frame: "_top"} do
          render SiteHeader::Nav do
            if current_user.registered? || current_admin_user.present?
              a(
                href: "#",
                class: "button ghost outline",
                data: {
                  controller: "modal-opener",
                  action: "modal-opener#open",
                  "modal-opener-dialog-param": "user-account-dialog"
                }
              ) do
                if current_user.persisted?
                  avatar_image(current_user)
                elsif current_admin_user.present?
                  avatar_image(current_admin_user)
                end
                span(class: "hidden md:inline") { nav_name }
              end

              render Dialog::Layout.new(
                id: "user-account-dialog",
                "aria-labelledby": "user-account-title",
                class: "max-w-lg p-xl m-auto",
                data: {
                  controller: "dialog",
                  action: "
                    click->dialog#tryClose
                  "
                }
              ) do |dialog|
                dialog.header do
                  dialog.close_button
                  dialog.feature_img src: avatar_url_for(current_user, size: 80), class: "rounded-full" if current_user.persisted?
                  dialog.title(id: "user-account-title") { plain "Your Account" }
                end
                dialog.body do
                  div(class: "flex flex-col gap-4") do
                    current_user_info if current_user.persisted?
                    current_admin_user_info if current_admin_user.present?
                  end
                  # render Forms::Stack do |form|
                  #   form.form_with model: current_user, url: users_registration_path do |f|
                  #     if f.object.errors.any?
                  #       ul do
                  #         f.object.errors.full_messages.each do |message|
                  #           li { message }
                  #         end
                  #       end
                  #     end
                  #     fieldset do
                  #       form.form_label f, :email, "Email address"
                  #       form.form_field f, :email_field, :email,
                  #         autocomplete: "email",
                  #         required: true
                  #     end
                  #     form.form_button f, "Save"
                  #   end
                  # end
                end

                dialog.footer do
                  flex_block do
                    if current_user.persisted?
                      button_to "Sign out", destroy_users_sessions_path, method: :delete, class: "button ghost outline"
                    end

                    if current_admin_user.present?
                      button_to "Sign out admin", destroy_admin_users_sessions_path, method: :delete, class: "button ghost outline"
                    end
                  end
                end
              end
            elsif Flipper.enabled?(:user_registration, current_admin_user)
              a(
                href: new_users_session_path,
                class: "button ghost outline"
                # data: {
                #   controller: "modal",
                #   action: "modal#show",
                #   "modal-dialog-param": "user-session-dialog"
                # }
              ) do
                plain "Subscribe"
              end
            end
          end
        end
      end

      def header_navigation_button_to(text, path, **)
        button_to(text, path, class: "
          flex justify-center items-center h-full px-2
          rounded mr-2 hover:bg-joy-bg-hover
        ", **)
      end

      def header_navigation_link_to(**, &)
        a(class: "
        flex justify-center items-center px-2
        rounded mr-2 hover:bg-joy-bg-hover
      ", **, &)
      end

      def nav_name
        return current_user.name if current_user.persisted?
        return "Admin" if current_admin_user.present?

        "Account"
      end

      def avatar_image(user)
        img src: avatar_url_for(user), class: "rounded-full md:mr-2", alt: "User avatar"
      end

      def avatar_url_for(user, size: 32)
        Gravatar.new(user.email).url(size: size)
      end

      def current_user_info
        div(class: "grid grid-gap rounded-lg joy-border-quiet") do
          div(class: "group relative flex items-center gap-x-6 p-4 leading-6 hover:bg-gray-50") do
            div(class: "flex-auto") do
              p(class: "block font-semibold") do
                plain current_user.name
              end
              p(class: "mt-1 text-gray-600") do
                plain current_user.email
              end
            end
          end
        end
      end

      def current_admin_user_info
        div(class: "grid grid-gap rounded-lg joy-border-quiet") do
          div(class: "group relative flex items-center gap-x-6 p-4 leading-6 hover:bg-gray-50") do
            div(class: "flex-auto") do
              p(class: "block font-semibold") do
                plain "Current Admin"
              end
              p(class: "mt-1 text-gray-600") do
                plain current_admin_user.email
              end
            end
          end
        end
      end
    end
  end
end
