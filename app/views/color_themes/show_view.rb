# frozen_string_literal: true

class ColorThemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo

  def initialize(color_scale:, curated_color_scales: [])
    @color_scale = color_scale
    @curated_color_scales = curated_color_scales
  end

  def view_template
    render Pages::Header.new(title: "Settings: Color Theme")
    div(class: "section-content container py-gap") do
      h3 { @color_scale.display_name }
      div(class: "color-theme color-theme:#{@color_scale.name.parameterize}") do
        @color_scale.weights.each do |weight, color|
          div(class: "color-swatch color-swatch__weight:#{weight}", style: "background-color: #{color.hex}") do
            div(class: "color-swatch__weight") { weight }
            div(class: "color-swatch__color") { color.hex.delete("#").upcase }
          end
        end
      end

      h3 { "Want to try a different color theme?" }
      p { "You can preview and save your desired color theme for this site. We have curated some options for you below." }

      form_with(url: color_theme_path, method: :get) do |f|
        fieldset(class: "flex items-center") do
          f.select :id,
            @curated_color_scales.map { |cs| [cs.display_name, cs.id] },
            {
              prompt: "Pick one!"
            },
            # https://stackoverflow.com/questions/68624668/how-can-i-submit-a-form-on-input-change-with-turbo-streams
            onchange: "this.form.requestSubmit()",
            class: "mr-2 bg-gray-50 border border-gray-300 text-small rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"

          whitespace
          span(class: "mr-2 font-small") { "OR" }
          whitespace
          link_to "I feel lucky!", color_theme_path(id: @curated_color_scales.sample.id), class: "button primary"
        end
      end
    end
  end
end
