module Users
  module HeaderNavigations
    class ShowView < ApplicationView
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo

      attr_reader :current_user, :current_admin_user

      def initialize(current_user:, current_admin_user:)
        @current_user = current_user
        @current_admin_user = current_admin_user
      end

      def view_template
        turbo_frame_tag :header_navigation do
          render SiteHeader::Nav do
            if current_admin_user.present?
              header_navigation_link_to \
                href: "/admin" do
                plain current_admin_user.email
              end

              header_navigation_button_to \
                "Sign out admin",
                destroy_admin_users_sessions_path,
                method: :delete do
                  plain
                end
            end

            if current_user.registered?
              a(
                href: "#",
                class: "button ghost outline",
                data: {
                  controller: "modal-opener",
                  action: "modal-opener#open",
                  "modal-opener-dialog-param": "user-account-dialog"
                }
              ) do
                img src: avatar_url_for(current_user), class: "rounded-full mr-2"
                plain current_user.name
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
                  dialog.feature_img src: avatar_url_for(current_user, size: 80), class: "rounded-full"
                  dialog.title(id: "user-account-title") { plain "Your Account" }
                end
                dialog.body do
                  user_info
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
                  button_to "Sign out", destroy_users_sessions_path, method: :delete, class: "button ghost outline"
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

      def avatar_url_for(user, size: 32)
        Gravatar.new(user.email).url(size: size)
      end

      def user_info
        div(class: "grid grid-gap rounded-lg joy-border-quiet") do
          div(class: "group relative flex items-center gap-x-6 p-4 leading-6 hover:bg-gray-50") do
            div(class: "flex-auto") do
              p(class: "block font-semibold text-gray-900") do
                plain current_user.name
              end
              p(class: "mt-1 text-gray-600") do
                plain current_user.email
              end
            end
          end
        end
      end
    end
  end
end
