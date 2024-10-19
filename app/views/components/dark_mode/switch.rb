class DarkMode::Switch < ApplicationComponent
  include PhlexConcerns::SvgTag

  def initialize(enable_description: false, enable_outline: false)
    @enable_description = enable_description
    @enable_outline = enable_outline
  end

  def view_template
    div(
      data_controller: "darkmode",
      class: "flex items-center justify-between"
    ) do
      button(
        data_action: " click->darkmode#cycle",
        id: "joy-cycle",
        type: "button",
        class: ["button ghost focus:ring-gray-200 dark:focus:ring-gray-700 focus:ring-2 focus:outline-none", ("outline" if enable_outline?)],
        aria_label: "Change Color Scheme",
        role: "button"
      ) do
        svg_tag "darkmode/moon.svg",
          data: {
            "darkmode-target" => "darkIcon"
          },
          class: "hidden w-5 h-5",
          fill: "currentColor",
          title: "Dark mode",
          desc: "Dark mode for the site is enabled",
          aria: true
        svg_tag "darkmode/sun.svg",
          data: {
            "darkmode-target" => "lightIcon"
          },
          class: "hidden w-5 h-5",
          fill: "currentColor",
          title: "Light mode",
          desc: "Light mode for the site is enabled",
          aria: true
        svg_tag "darkmode/eclipse.svg",
          data: {
            "darkmode-target" => "systemIcon"
          },
          class: "hidden w-5 h-5",
          fill: "currentColor",
          title: "System mode",
          desc: "System mode for the site is enabled",
          aria: true
        span(
          role: "heading",
          aria_label: "Change Color Scheme",
          aria_roledescription: "heading",
          data_darkmode_target: "description",
          data_action: "click->darkmode#cycle",
          class: ["ml-2 cursor-pointer", ("hidden" if !enable_description?)]
        ) { "Light Mode" }
      end
    end
  end

  def enable_outline?
    @enable_outline
  end

  def enable_description?
    @enable_description
  end
end
