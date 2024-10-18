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
              header_navigation_link_to \
                href: users_dashboard_path do
                  plain current_user.name
                  img src: avatar_url_for(current_user, size: 24), class: "rounded-full mr-1"
                end

              header_navigation_button_to \
                "Sign out",
                destroy_users_sessions_path,
                method: :delete
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

      def avatar_url_for(user, opts = {})
        size = opts[:size || 32]

        hash = Digest::MD5.hexdigest("fooadjflakdfalwdk@example.com".downcase)
        "https://secure.gravatar.com/avatar/#{hash}.png?s=#{size}&d=retro"
      end
    end
  end
end
