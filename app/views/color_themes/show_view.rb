# frozen_string_literal: true

class ColorThemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::FormWith

  def initialize(color_scale:, curated_color_scales: [])
    @color_scale = color_scale
    @curated_color_scales = curated_color_scales
  end

  def view_template
    render Pages::Header.new(title: "Settings: Color Theme")
    div(class: "section-content container py-gap") do
      p { "You can preview and save your desired color theme for this site. We have curated some options for you below." }

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
      form_with(url: color_theme_path, method: :get) do |f|
        fieldset do
          f.select :id, @curated_color_scales.map { |cs| [cs.display_name, cs.id] }, include_blank: "Pick one!"
        end
        fieldset do
          f.submit "Show me!", class: "button primary"
        end
      end
    end
  end
end
