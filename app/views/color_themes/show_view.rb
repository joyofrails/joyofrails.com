# frozen_string_literal: true

class ColorThemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor

  def initialize(color_theme:, fallback_color_scale: nil, curated_color_scales: [], selected: false, saved: false)
    @color_theme = color_theme
    @color_scale = color_theme.color_scale
    @fallback_color_scale = fallback_color_scale
    @curated_color_scales = curated_color_scales
    @selected = selected
    @saved = saved
  end

  def view_template
    content_for :head do
      render("application/theme/color")
    end
    render Pages::Header.new(title: "Theme")
    div(class: "section-content container py-gap") do
      if @saved || @selected
        h3 do
          plain "You are now #{@saved ? "using" : "previewing"} the"
          whitespace
          span(class: "emphasis") { @color_scale.display_name }
          whitespace
          plain "color scheme"
        end
      else
        h3 { "Want to try a different color scheme?" }
      end

      p { "You can preview and save your desired color scheme for this site. We have curated some options for you below." }

      div(class: "flex items-center") do
        span(class: "mr-2 text-small") { "Preview" }

        form_with(model: @color_theme, url: url_for, method: :get) do |f|
          fieldset do
            f.select(
              :color_scale_id,
              @curated_color_scales.map { |cs| [cs.display_name, cs.id] },
              {
                prompt: "Pick one!",
                selected: @selected && @color_scale.id
              },
              # requestSubmit and Turbo
              # https://stackoverflow.com/questions/68624668/how-can-i-submit-a-form-on-input-change-with-turbo-streams
              onchange: "this.form.requestSubmit()",
              class: "mr-2"
            )
          end
        end

        span(class: "mr-2 text-small") { "OR" }

        link_to "I feel lucky!",
          color_theme_path(color_theme: {color_scale_id: @curated_color_scales.sample.id}),
          class: "button secondary mr-2"

        if @selected && @color_scale != @fallback_color_scale
          span(class: "mr-2 text-small") { "OR" }

          button_to "Reset preview",
            color_theme_path(color_theme: {color_scale_id: @fallback_color_scale.id}),
            method: :patch,
            class: "button tertiary mr-2"
        end
      end

      if @selected
        div(class: "flex items-center") do
          span(class: "mr-2 text-small") { plain "Save" }

          button_to "Save this color scheme",
            color_theme_path(color_theme: {color_scale_id: @color_scale.id}),
            method: :patch,
            class: "button primary mr-2"

          span(class: "mr-2 text-small") { unsafe_raw "&bull;" }

          button_to "Reset to default",
            color_theme_path(color_theme: {color_scale_id: ColorScale.cached_default.id}),
            method: :patch,
            class: "button tertiary mr-2"
        end
      end

      h3 { display_name }

      div(class: "color-scheme color-scheme__#{@color_scale.name.parameterize}") do
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
