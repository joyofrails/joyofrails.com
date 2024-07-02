# frozen_string_literal: true

class ColorThemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo

  def initialize(color_scale:, curated_color_scales: [], selected: false)
    @color_scale = color_scale
    @curated_color_scales = curated_color_scales
    @selected = selected
  end

  def view_template
    render Pages::Header.new(title: "Settings: Color Theme")
    div(class: "section-content container py-gap") do
      h3 { "Want to try a different color theme?" }

      p { "You can preview and save your desired color theme for this site. We have curated some options for you below." }

      form_with(url: url_for, method: :get) do |f|
        fieldset(class: "flex items-center") do
          f.select :id,
            @curated_color_scales.map { |cs| [cs.display_name, cs.id] },
            {
              prompt: "Pick one!",
              selected: (@selected ? @color_scale.id : nil)
            },
            # requestSubmit and Turbo
            # https://stackoverflow.com/questions/68624668/how-can-i-submit-a-form-on-input-change-with-turbo-streams
            onchange: "this.form.requestSubmit()",
            class: "mr-2 bg-gray-50 border border-gray-300 text-small rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"

          span(class: "mr-2 text-small") { "OR" }
          link_to "I feel lucky!", url_for(id: @curated_color_scales.sample.id), class: "button primary mr-2"
          if @selected
            span(class: "mr-2 text-small") { unsafe_raw "&bull;" }
            link_to "Reset to default", url_for, class: "button secondary"
          end
        end
      end

      h3 { display_name }
      div(class: "color-theme color-theme:#{@color_scale.name.parameterize}") do
        @color_scale.weights.each do |weight, color|
          div(class: "color-swatch color-swatch__weight:#{weight}", style: "background-color: #{color.hex}") do
            div(class: "color-swatch__weight") { weight }
            div(class: "color-swatch__color") { color.hex.delete("#").upcase }
          end
        end
      end
    end
  end

  private

  def default_color_scale? = @color_scale.id == ColorScale.cached_default.id

  def display_name
    if default_color_scale?
      "#{@color_scale.display_name} (default)"
    else
      @color_scale.display_name
    end
  end
end
