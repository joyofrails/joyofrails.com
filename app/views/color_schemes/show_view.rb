# frozen_string_literal: true

class ColorSchemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ContentFor

  def initialize(settings:, fallback_color_scheme: nil, curated_color_schemes: [], selected: false, saved: false)
    @settings = settings
    @color_scheme = settings.color_scheme
    @fallback_color_scheme = fallback_color_scheme
    @curated_color_schemes = curated_color_schemes
    @selected = selected
    @saved = saved
  end

  def view_template
    content_for :head do
      render("application/theme/color")
    end
    render Pages::Header.new(title: "Theme: Color")
    div(class: "section-content container py-gap") do
      if @saved || @selected
        h3 do
          plain "You are now #{@saved ? "using" : "previewing"} the"
          whitespace
          span(class: "emphasis") { @color_scheme.display_name }
          whitespace
          plain "color scheme"
        end
      else
        h3 { "Want to try a different color scheme?" }
      end

      p { "You can preview and save your desired color scheme for this site. We have curated some options for you below." }

      div(class: "flex items-center") do
        span(class: "mr-2 text-small") { "Preview" }

        form_with(model: @settings, url: url_for, method: :get) do |f|
          fieldset do
            f.select(
              :color_scheme_id,
              @curated_color_schemes.map { |cs| [cs.display_name, cs.id] },
              {
                prompt: "Pick one!",
                selected: @selected && @color_scheme.id
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
          settings_color_scheme_path(settings: {color_scheme_id: @curated_color_schemes.sample.id}),
          class: "button secondary mr-2"

        if @selected && @color_scheme != @fallback_color_scheme
          span(class: "mr-2 text-small") { "OR" }

          button_to "Reset preview",
            settings_color_scheme_path(settings: {color_scheme_id: @fallback_color_scheme.id}),
            method: :patch,
            class: "button tertiary mr-2"
        end
      end

      if @selected
        div(class: "flex items-center") do
          span(class: "mr-2 text-small") { plain "Save" }

          button_to "Save this color scheme",
            settings_color_scheme_path(settings: {color_scheme_id: @color_scheme.id}),
            method: :patch,
            class: "button primary mr-2"

          span(class: "mr-2 text-small") { unsafe_raw "&bull;" }

          button_to "Reset to default",
            settings_color_scheme_path(settings: {color_scheme_id: ColorScheme.cached_default.id}),
            method: :patch,
            class: "button tertiary mr-2"
        end
      end

      h3 { display_name }

      div(class: "color-scheme color-scheme__#{@color_scheme.name.parameterize}") do
        @color_scheme.weights.each do |weight, color|
          div(class: "color-swatch color-swatch__weight:#{weight}", style: "background-color: #{color.hex}") do
            div(class: "color-swatch__weight") { weight }
            div(class: "color-swatch__color") { color.hex.delete("#").upcase }
          end
        end
      end
    end
  end

  private

  def default_color_scheme? = @color_scheme.id == ColorScheme.cached_default.id

  def display_name
    if default_color_scheme?
      "#{@color_scheme.display_name} (default)"
    else
      @color_scheme.display_name
    end
  end
end
