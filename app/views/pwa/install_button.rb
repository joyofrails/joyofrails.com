class Pwa::InstallButton < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag
  include PhlexConcerns::SvgTag
  include PhlexConcerns::FlexBlock

  def view_template
    div(data_controller: "pwa-installation") do
      flex_block do
        button(
          data_pwa_installation_target: "installButton",
          data_action: "click->pwa-installation#install",
          class: "button primary hidden"
        ) do
          install_icon
          whitespace
          plain "Install to Homescreen"
        end
        link_to pwa_installation_instructions_path,
          class: "button primary hidden",
          data: {
            pwa_installation_target: "infoButton",
            action: "click->pwa-installation#openDialog",
            turbo_frame: "pwa_installation_instructions"
          } do
          install_icon
          whitespace
          plain "Install to Homescreen"
        end
        dialog(
          data_pwa_installation_target: "dialog",
          data_action: "click->pwa-installation#clickOutside",
          class: "p-4"
        ) do
          turbo_frame_tag "pwa_installation_instructions"
          a(
            data_action: "click->pwa-installation#closeDialog",
            href: "#",
            class: "button transparent"
          ) { "Close" }
        end
        div(data_pwa_installation_target: "message", class: "hidden")
      end
    end
  end

  private

  def install_icon
    svg_tag "install-app.svg", class: "w-[24px] mr-1", aria_hidden: true
  end
end
